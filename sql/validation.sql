-- Data quality and reconciliation checks.

-- Expected: 20 raw rows for the supplied CSV.
SELECT COUNT(*) AS raw_records
FROM `sales_dw.raw_sales`;

-- Expected: 10 unique products.
SELECT COUNT(*) AS product_count
FROM `sales_dw.dim_product`;

-- Expected: 18 positive-value sales transactions.
SELECT COUNT(*) AS valid_sales
FROM `sales_dw.fact_sales`;

-- Expected: 0 zero-dollar transactions in the fact table.
SELECT COUNT(*) AS zero_sales_in_fact
FROM `sales_dw.fact_sales`
WHERE sales_amount = 0;

-- Expected: total_sales = 17600, total_quantity = 34,
-- total_transactions = 18 for the supplied CSV.
SELECT
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_quantity,
    SUM(sales_amount) AS total_sales
FROM `sales_dw.fact_sales`;
