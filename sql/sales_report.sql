-- Product-wise aggregated sales report.

SELECT
    p.product_id,
    SUM(f.quantity) AS total_quantity,
    COUNT(f.sale_id) AS total_transactions,
    SUM(f.sales_amount) AS total_sales
FROM `sales_dw.fact_sales` AS f
INNER JOIN `sales_dw.dim_product` AS p
    ON f.product_id = p.product_id
GROUP BY p.product_id
ORDER BY p.product_id;
