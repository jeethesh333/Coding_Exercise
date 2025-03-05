Once the files have been saved as csv format. I have created the tables with the exact matching column names and imported the appropriate data into the my_database.db.

I will be using Sqlite for this SQL questions.


3.
SELECT rewardsReceiptStatus,  
    AVG(totalSpent) AS avgSpend  
FROM receipts  
WHERE rewardsReceiptStatus IN ('FINISHED', 'REJECTED')  
GROUP BY rewardsReceiptStatus  
ORDER BY avgSpend DESC;  

This query calculates the average total spent for each rewards receipt status ('FINISHED' or 'REJECTED') by filtering the rows, grouping by rewardsReceiptStatus, computing the average, ordering the results in descending order, and outputting the status with the higher average spend. It’s more efficient than using CASE and HAVING because it directly filters and groups the data without extra conditional checks, allowing the SQL engine to optimize the aggregation process.

 4.
SELECT rewardsReceiptStatus
FROM receipts
WHERE rewardsReceiptStatus IN ('FINISHED', 'REJECTED')
GROUP BY rewardsReceiptStatus
ORDER BY SUM(purchasedItemCount) DESC
LIMIT 1;

Similar to the previous query, the only thing that changes is instead of average total spent, it is total number of items purchased.
