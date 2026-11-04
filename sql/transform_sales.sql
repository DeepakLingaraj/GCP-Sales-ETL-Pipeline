-- ETL transformation:
-- 1. Build the Product dimension from distinct product IDs.
-- 2. Build the Sales fact table, excluding zero-dollar sales.
--
-- Prerequisite: upload data/sales_data.csv to sales_dw.raw_sales
-- using schemas/raw_sales_schema.json.

CREATE OR REPLACE TABLE `sales_dw.dim_product` AS
SELECT DISTINCT
    product_id
FROM `sales_dw.raw_sales`;

CREATE OR REPLACE TABLE `sales_dw.fact_sales` AS
SELECT
    sale_id,
    product_id,
    sale_date,
    quantity,
    CAST(amount AS NUMERIC) AS sales_amount
FROM `sales_dw.raw_sales`
WHERE amount > 0;
