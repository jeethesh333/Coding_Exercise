## SQL Queries for Business Questions

Once the files have been saved as CSV format, I have created the tables with the exact matching column names and imported the appropriate data into `my_database.db`.

I will be solving questions 1, 3, and 4. Even though I was able to solve the remaining questions, I am having a hard time extracting brand names as I fell short of information.

### Question 1: Top 5 Brands by Receipts Scanned for the Most Recent Month

```sql
-- Check the data for the most recent month
WITH recent_month AS (
    -- Step 1: Get the most recent month available in the dataset
    SELECT strftime('%Y-%m', dateScanned) AS latest_month
    FROM receipts
    ORDER BY dateScanned DESC
    LIMIT 1
)

-- Select the top 5 brands based on the count of receipts in the most recent month
SELECT rr.brandCode, COUNT(DISTINCT r._id) AS receipt_count
FROM receipts r
JOIN rewardsReceiptItemList rr ON r._id = rr.receiptId
-- Filter receipts to only include those from the most recent month
WHERE strftime('%Y-%m', r.dateScanned) = (SELECT latest_month FROM recent_month) 
GROUP BY rr.brandCode 
-- Order the results by the count of receipts in descending order
ORDER BY receipt_count DESC
-- Limit the results to the top 5 brands
LIMIT 5;
```

#### Explanation
This SQLite query identifies the top 5 brands by the number of unique receipts scanned in the most recent month, using a star schema with `receipts` as the fact table and `rewardsReceiptItemList` as a dimension. It starts with a CTE (`recent_month`) that extracts the latest year-month from the TEXT-formatted `dateScanned` (e.g., `'2021-01-03 15:25:31.000'` becomes `'2021-01'`) via `strftime('%Y-%m', dateScanned)`, sorting descending and limiting to one. The main query joins `receipts` (aliased `r`) to `rewardsReceiptItemList` (aliased `rr`) on `r._id = rr.receiptId`, filters to the recent month using the CTE, and groups by `rr.brandCode` to count distinct `r._id` values (`COUNT(DISTINCT r._id)`), ensuring a receipt with multiple items counts once per brand. Results are ordered by `receipt_count` descending and limited to 5. However, despite the `LIMIT 5`, only 3 rows appear, suggesting either fewer than 5 distinct brands exist in the recent month’s data or some brands have no linked items, efficiently answering the question while handling the TEXT date format and reflecting data sparsity.

#### Potential Considerations
- `strftime` on every row and full-table scan in the CTE could be slow for large datasets. Indexing `dateScanned` or pre-computing a `year_month` column would help.
- Empty `brandCode` values might exclude some receipts unless filled.
- Since the NLP technique is not 100% accurate, the output is not fully reliable, but the process is correct.

#### Output
| brandCode       | receipt_count |
|-----------------|---------------|
|                 | 17            |
| Thindust Summer | 13            |
| Mueller Austria | 13            |

### Question 3: Average Spend by Receipt Status

```sql
SELECT rewardsReceiptStatus,  
    AVG(totalSpent) AS avgSpend  
FROM receipts  
WHERE rewardsReceiptStatus IN ('FINISHED', 'REJECTED')  
GROUP BY rewardsReceiptStatus  
ORDER BY avgSpend DESC;
```

#### Explanation
This query calculates the average total spent for each rewards receipt status ('FINISHED' or 'REJECTED') by filtering the rows, grouping by `rewardsReceiptStatus`, computing the average with `AVG(totalSpent)`, ordering the results in descending order, and outputting the status with the higher average spend. It’s more efficient than using `CASE` and `HAVING` because it directly filters and groups the data without extra conditional checks, allowing the SQL engine to optimize the aggregation process.

#### Output
| rewardsReceiptStatus | avgSpend         |
|----------------------|------------------|
| FINISHED             | 80.854305019305  |
| REJECTED             | 23.3260563380282 |

### Question 4: Total Spend by Receipt Status

```sql
SELECT rewardsReceiptStatus,  
    SUM(totalSpent) AS totalSpend  
FROM receipts  
WHERE rewardsReceiptStatus IN ('FINISHED', 'REJECTED')  
GROUP BY rewardsReceiptStatus  
ORDER BY totalSpend DESC;
```

#### Explanation
This query calculates the total spend for each rewards receipt status ('FINISHED' or 'REJECTED') by filtering the rows, grouping by `rewardsReceiptStatus`, summing the `totalSpent` with `SUM(totalSpent)`, and ordering the results in descending order. The `rewardsReceiptStatus` 'FINISHED' has a higher total spend than 'REJECTED', providing a straightforward comparison of total expenditure across these statuses.

#### Output
| rewardsReceiptStatus | totalSpend |
|----------------------|------------|
| FINISHED             | 41882.53   |
| REJECTED             | 1656.15    |

[Next question](https://github.com/jeethesh333/Coding_Exercise/blob/main/third_question.md)
