-- -- Create table for Users
-- CREATE TABLE users (
--     _id TEXT PRIMARY KEY,
--     active BOOLEAN,
--     createdDate TEXT,
--     lastLogin TEXT,
--     role TEXT,
--     signUpSource TEXT,
--     state TEXT
-- ); 

-- -- Create table for Brands
-- CREATE TABLE brands (
--     _id TEXT PRIMARY KEY,
--     barcode REAL,
--     category TEXT,
--     categoryCode TEXT,
--     name TEXT,
--     topBrand BOOLEAN,
--     brandCode TEXT
-- );

-- -- Create table for Receipts
-- CREATE TABLE receipts (
--     _id TEXT PRIMARY KEY,
--     bonusPointsEarned INTEGER,
--     bonusPointsEarnedReason TEXT,
--     createDate TEXT,
--     dateScanned TEXT,
--     finishedDate TEXT,
--     modifyDate TEXT,
--     pointsAwardedDate TEXT,
--     pointsEarned INTEGER,
--     purchaseDate TEXT,
--     purchasedItemCount INTEGER,
--     rewardsReceiptStatus TEXT,
--     totalSpent REAL,
--     userId TEXT,
--     FOREIGN KEY(userId) REFERENCES users(_id)
-- );

-- -- Create table for rewardsReceiptItemList
-- CREATE TABLE rewardsReceiptItemList (
--     item_id TEXT PK,
--     barcode TEXT,
--     description TEXT,
--     finalPrice REAL,
--     itemPrice REAL,
--     needsFetchReview BOOLEAN,
--     partnerItemId INTEGER,
--     preventTargetGapPoints BOOLEAN,
--     quantityPurchased INTEGER,
--     userFlaggedBarcode REAL,
--     userFlaggedNewItem BOOLEAN,
--     userFlaggedPrice REAL,
--     userFlaggedQuantity REAL,
--     needsFetchReviewReason TEXT,
--     pointsNotAwardedReason TEXT,
--     pointsPayerId TEXT,
--     rewardsGroup TEXT,
--     rewardsProductPartnerId TEXT,
--     userFlaggedDescription TEXT,
--     originalMetaBriteBarcode REAL,
--     originalMetaBriteDescription TEXT,
--     brandCode TEXT,
--     competitorRewardsGroup TEXT,
--     discountedItemPrice REAL,
--     originalReceiptItemText TEXT,
--     itemNumber REAL,
--     originalMetaBriteQuantityPurchased REAL,
--     pointsEarned REAL,
--     targetPrice REAL,
--     competitiveProduct TEXT,
--     originalFinalPrice REAL,
--     originalMetaBriteItemPrice REAL,
--     deleted TEXT,
--     priceAfterCoupon REAL,
--     metabriteCampaignId TEXT,
--     receiptId TEXT,
--     FOREIGN KEY(receiptId) REFERENCES receipts(_id),
--     FOREIGN KEY(brandCode) REFERENCES brands(brandCode)
-- );

 
--  -- Create table for CPG
--  CREATE TABLE cpg (
--     cpg_id TEXT PRIMARY KEY,
--     cpg_ref TEXT
-- );

-- -- Import data from CSV files into the respective tables
-- .mode csv
-- .import --skip 1 data/output_data/users.csv users
-- .import --skip 1 data/output_data/receipts.csv receipts
-- .import --skip 1 data/output_data/cpg.csv cpg
-- .import --skip 1 data/output_data/brands.csv brands
-- .import --skip 1 data/output_data/rewardsReceiptItemList.csv rewardsReceiptItemList

-- Enable headers for the output
-- .headers ON





-- Question 1
-- -- Check the data for the most recent month
-- WITH recent_month AS (
--     -- Step 1: Get the most recent month available in the dataset
--     SELECT strftime('%Y-%m', dateScanned) AS latest_month
--     FROM receipts
--     ORDER BY dateScanned DESC
--     LIMIT 1
-- )

-- -- select the top 5 brands based on the count of receipts in the most recent month
-- SELECT rr.brandCode, COUNT(DISTINCT r._id) AS receipt_count
-- FROM receipts r
-- JOIN rewardsReceiptItemList rr ON r._id = rr.receiptId
-- -- Filter receipts to only include those from the most recent month
-- WHERE strftime('%Y-%m', r.dateScanned) = (SELECT latest_month FROM recent_month) 
-- GROUP BY rr.brandCode 
-- -- Order the results by the count of receipts in descending order
-- ORDER BY receipt_count DESC
-- -- Limit the results to the top 5 brands
-- LIMIT 5;


-- Question 3
-- SELECT rewardsReceiptStatus,  
--     AVG(totalSpent) AS avgSpend  
-- FROM receipts  
-- WHERE rewardsReceiptStatus IN ('FINISHED', 'REJECTED')  
-- GROUP BY rewardsReceiptStatus  
-- ORDER BY avgSpend DESC; 

-- Question 4
-- SELECT rewardsReceiptStatus,  
--     SUM(totalSpent) AS totalSpend  
-- FROM receipts  
-- WHERE rewardsReceiptStatus IN ('FINISHED', 'REJECTED')  
-- GROUP BY rewardsReceiptStatus  
-- ORDER BY totalSpend DESC; 


