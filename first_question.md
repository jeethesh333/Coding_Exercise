This structure follows a star schema where receipts is the central fact table, and the other tables act as dimension tables, optimizing for analytical queries.


In the initial data provided, there are three files users, brands, receipts. In receipts file there is another table nested
which is rewardsReceiptItemList. In brands table there is another table nested which is cpg. So, instead of three tables now it is five tables.

Assumptions: 
1.For some tables, as there are more columns, I am only writing certain columns to make it easier.  
2.since cpg table doesn't have direct relation with other tables. I am creating cpg_id column in brands table as a refrence to cpg table.



---

### Relational Diagram (Star Schema)

```
+----------------+       +--------------------------------+
|    users       |       |    rewardsReceiptItemList     |  (Fact Table)
+----------------+       +--------------------------------+
| user_id (PK)   |<----->| item_id (PK)                  |
| active         |       | receipt_id                    |
| createdDate    |       | user_id (FK) -----------------+
| role           |       | brand_code (FK) --------+     |
+----------------+       | barcode                 |     |
                         | finalPrice              |     |
                         | quantityPurchased       |     |
                         | pointsEarned            |     |
                         +-------------------------+     |
                                                         |
+----------------+       +----------------+              |
|   receipts     |       |    brands      |              |
+----------------+       |----------------+              |
| receipt_id (PK)|<------+ _id (PK)       |              |
| totalSpent     |       | brand_code (PK)|<-------------+
| purchaseDate   |       | name           |
| pointsAwardedDate|     | category       |
+----------------+       +----------------+

+----------------+
|      cpg       |
+----------------+
| cpg_id (PK)    |
| cpg_ref        |
+----------------+
```

---

### Explanation of the Diagram

1. **Fact Table: rewardsReceiptItemList**
   - **Primary Key**: `item_id`
   - **Foreign Keys**:
     - `user_id` (links to `users.user_id`)
     - `receipt_id` (links to `receipts.receipt_id`)
     - `brand_code` (links to `brands.brand_code`)
   - **Fields**: Contains quantitative measures like `finalPrice`, `quantityPurchased`, and `pointsEarned`, making it the central fact table for transactional data.
   - **Role**: This table captures detailed item-level data from receipts, which is the core of analysis in a star schema.

2. **Dimension Table: users**
   - **Primary Key**: `user_id` (renamed `_id` to `user_id` for clarity)
   - **Fields**: Descriptive attributes like `active`, `createdDate`, and `role`.
   - **Relationship**: Links directly to `rewardsReceiptItemList` via `user_id`, providing user context for transactions.

3. **Dimension Table: receipts**
   - **Primary Key**: `receipt_id` (renamed `_id` to `receipt_id` for clarity)
   - **Fields**: Descriptive attributes like `totalSpent`, `purchaseDate`, and `pointsAwardedDate`.
   - **Relationship**: Links directly to `rewardsReceiptItemList` via `receipt_id`, providing receipt-level context.

4. **Dimension Table: brands**
   - **Primary Key**: `brand_code` (using `brandCode` as the joinable key instead of `_id` for consistency with `rewardsReceiptItemList`)
   - **Fields**: Descriptive attributes like `name` and `category`.
   - **Relationship**: Links directly to `rewardsReceiptItemList` via `brand_code`, providing brand context for items.

5. **Dimension Table: cpg**
   - **Primary Key**: `cpg_id`
   - **Fields**: `cpg_ref`
   - **Relationship**: Standalone in this diagram. In a real-world scenario, it might connect to `brands` or `rewardsReceiptItemList` via an additional foreign key (not specified in your schema).

---

### Star Schema Explanation

#### Characteristics of a Star Schema:
- **Fact Table**: A single central table (`rewardsReceiptItemList`) contains quantitative data (facts) that are the focus of analysis (e.g., sales amounts, quantities, points).
- **Dimension Tables**: Surrounding tables (`users`, `receipts`, `brands`) provide descriptive context (dimensions) and are denormalized, meaning they don’t split into further sub-tables.
- **Direct Relationships**: The fact table connects directly to dimension tables via foreign keys, forming a "star" pattern with no intermediate tables.

#### How This Fits a Star Schema:
1. **Central Fact Table**:
   - `rewardsReceiptItemList` is the fact table, storing measurable data like `finalPrice`, `quantityPurchased`, and `pointsEarned`. It’s the hub of the star.

2. **Dimension Tables**:
   - `users`: Describes who made the purchase.
   - `receipts`: Describes when and how much was spent on the receipt.
   - `brands`: Describes what was purchased (brand details).
   - These tables are denormalized and directly linked to the fact table via `user_id`, `receipt_id`, and `brand_code`.

3. **Adjustments for Star Schema**:
   - I moved `user_id` directly into `rewardsReceiptItemList` as a foreign key, flattening the relationship from the original schema where `receipts` acted as an intermediary. This simplifies queries and aligns with star schema principles.
   - `brand_code` is used as the primary key in `brands` (instead of `_id`) to match the foreign key in `rewardsReceiptItemList`, ensuring a clean join.
   - `cpg` remains standalone because no explicit relationship is defined, but it could be integrated as an additional dimension if needed.

4. **Why Not Snowflake?**:
   - In a snowflake schema, dimension tables would be normalized into multiple related tables (e.g., splitting `users` into separate tables for roles or states). Here, all dimensions are kept flat, adhering to the star schema’s simplicity.

#### Benefits of This Star Schema:
- **Query Performance**: Direct joins between the fact table and dimensions make queries faster and simpler (e.g., “Total points earned by user and brand”).
- **Simplicity**: Denormalized dimensions reduce complexity for analysts and reporting tools.
- **Flexibility**: Easily supports aggregations like total spend by user, receipt, or brand.






![img1](images/Relational_model.jpeg)

Here is the ER diagram showing:
Entities (Tables) with attributes
Primary Keys (PK) & Foreign Keys (FK) 
Relationships with cardinality (1:N, N:1)

![img1](images/ER_diagram.jpeg)
