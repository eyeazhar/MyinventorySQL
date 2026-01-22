STEP 1: 
    
CREATE DATABASE inventory_db;
USE inventory_db;

STEP 2: -- CREATE TABLES --
    
CREATE TABLE inventory_raw (
    sku_id VARCHAR(50),
    product_name VARCHAR(100),
    category VARCHAR(50),
    quantity INT,
    warehouse VARCHAR(50),
    last_updated DATE
);

CREATE TABLE inventory_cleaned (
    sku_id VARCHAR(50),
    product_name VARCHAR(100),
    category VARCHAR(50),
    quantity INT,
    warehouse VARCHAR(50),
    last_updated DATE,
    data_status VARCHAR(20),
    PRIMARY KEY (sku_id)
);

STEP 3: -- IMPORT DATA TO SQL --
    
LOAD DATA INFILE 'PATH TO CSV FILE'
INTO TABLE inventory_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

STEP 4: -- VALIDATION QUERIES --
    
-- Negative stock check
SELECT * FROM inventory_raw
WHERE quantity < 0;

-- Missing SKU check
SELECT * FROM inventory_raw
WHERE sku_id IS NULL OR sku_id = '';

-- Duplicate SKU check
SELECT sku_id, COUNT(*) AS duplicate_count
FROM inventory_raw
GROUP BY sku_id
HAVING COUNT(*) > 1;

STEP 5: -- DATA CLEANSING --
-- Insert valid records
INSERT INTO inventory_cleaned
SELECT
    sku_id,
    product_name,
    category,
    quantity,
    warehouse,
    last_updated,
    'VALID'
FROM inventory_raw
WHERE quantity >= 0
  AND sku_id IS NOT NULL
  AND sku_id <> '';

-- Insert invalid records
INSERT INTO inventory_cleaned
SELECT
    IFNULL(sku_id, 'UNKNOWN'),
    product_name,
    category,
    quantity,
    warehouse,
    last_updated,
    'INVALID'
FROM inventory_raw
WHERE quantity < 0
   OR sku_id IS NULL
   OR sku_id = '';

STEP 6: -- FIXING DATA --

-- Fix negative quantities
UPDATE inventory_cleaned
SET quantity = 0
WHERE quantity < 0;

-- Remove invalid records (optional)
DELETE FROM inventory_cleaned
WHERE data_status = 'INVALID';

STEP 7: -- FINAL OUTPUT --

SELECT * FROM inventory_cleaned
LIMIT 20;
