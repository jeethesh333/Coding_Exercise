## Data Quality Issues

When designing a star schema like the one I’ve developed (with `receipts` as the fact table and `users`, `rewardsReceiptItemList`, `brands`, and `cpg` as dimension tables), data quality issues can significantly impact the reliability of analysis. Below, I will list the data quality issues I found in this schema.

- **Duplicate Values in `users` Table**
  - I have found there are some duplicate values in the `_id` column in the `users` table. Since `_id` is a primary key, I have removed the duplicate values.

- **Mismatch Between `rewardsReceiptItemList` and `brands`**
  - After thorough analysis, I came to know that there are no matching columns for the `rewardsReceiptItemList` and `brands` tables. Even the `brandCode` column in both tables doesn’t have matching data since the `brandCode` in `rewardsReceiptItemList` has most of its values as null. 
  - So, I have filled the `brandCode` using the `description` in `rewardsReceiptItemList`, where `description` looks like 'DORITOS TORTILLA CHIP SPICY SWEET CHILI REDUCED FAT BAG 1 OZ,' in which 'DORITOS' is the brand. I have used NLP techniques to extract the brand from the `description`. Although it is not 100% accurate, I believe this is one of the techniques that can be used to extract the brand since there is not enough information.

- **Isolated `cpg` Table**
  - The `cpg` table is isolated with no foreign key linking it to `users`, `brands`, `rewardsReceiptItemList`, or `receipts`, making its role unclear.

- **Inconsistent Data Types**
  - Fields with inconsistent data types across tables (e.g., `barcode` as REAL in `brands` but TEXT in `rewardsReceiptItemList`) could cause join failures or incorrect filtering. 
  - Date fields stored as TEXT (e.g., `createDate` or `modifyDate` in `rewardsReceiptItemList`) might lead to errors if not properly converted.

- **Improper `brandCode` Values in `brands`**
  - The `brandCode` column values in the `brands` table are not properly given. It should be 'STARBUCKS' or 'GODIVA DRY PACKAGED DESSERTS', but for some rows, it is mentioned as 'TEST BRANDCODE @1598635634882' or 'TEST BRANDCODE @1598639199674'. 
  - As mentioned in the exercise description, the `brandCode` is a string that corresponds with the brand column in a partner product file, but the partner product file is not given.

- **Missing Values**
  - Missing values in most of the tables could affect future analysis. For example, some of the data in `totalSpent` from `receipts` is 0.0 and some of them are null. Even though the user didn’t spend anything, bonus points have been earned.


---

[Next question](https://github.com/jeethesh333/Coding_Exercise/blob/main/fourth_question.md)


