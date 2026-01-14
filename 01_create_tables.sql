CREATE DATABASE IF NOT EXISTS inventory_db;
USE inventory_db;

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
