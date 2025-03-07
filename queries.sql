-- CREATE TABLE cpg (
--     cpg_id TEXT PRIMARY KEY,
--     cpg_ref TEXT
-- );

-- CREATE TABLE brands (
--     _id TEXT PRIMARY KEY,
--     barcode REAL,
--     category TEXT,
--     categoryCode TEXT,
--     name TEXT,
--     topBrand BOOLEAN,
--     brandCode TEXT
-- );

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

-- CREATE TABLE rewardsReceiptItemList (
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
--     FOREIGN KEY(receiptId) REFERENCES receipts(_id)
-- );

-- CREATE TABLE users (
--     _id TEXT PRIMARY KEY,
--     active BOOLEAN,
--     createdDate TEXT,
--     lastLogin TEXT,
--     role TEXT,
--     signUpSource TEXT,
--     state TEXT
-- );


-- .mode csv
-- .import --skip 1 data/output_data/users.csv users
-- .import --skip 1 data/output_data/receipts.csv receipts
-- .import --skip 1 data/output_data/cpg.csv cpg
-- .import --skip 1 data/output_data/brands.csv brands
-- .import --skip 1 data/output_data/rewardsReceiptItemList.csv rewardsReceiptItemList

.headers ON
-- PRAGMA table_info(rewardsReceiptItemList);





SELECT rewardsReceiptStatus
FROM receipts
WHERE rewardsReceiptStatus IN ('FINISHED', 'REJECTED')
GROUP BY rewardsReceiptStatus
ORDER BY SUM(purchasedItemCount) DESC
LIMIT 1;



-- SELECT rewardsReceiptStatus
-- FROM receipts  
-- WHERE rewardsReceiptStatus IN ('FINISHED', 'REJECTED')  
-- GROUP BY rewardsReceiptStatus  
-- ORDER BY AVG(totalSpent) DESC
-- LIMIT 1;










