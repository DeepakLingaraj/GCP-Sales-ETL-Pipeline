# GCP Sales ETL Pipeline

A beginner-friendly batch ETL project using Google Cloud Platform (GCP) and BigQuery. It loads sales transactions from a CSV file, removes zero-dollar transactions, creates a Product dimension and Sales fact table, and produces a product-wise aggregated report.

## Architecture

`data/sales_data.csv` → BigQuery `sales_dw.raw_sales` → SQL transformation → `sales_dw.dim_product` + `sales_dw.fact_sales` → aggregated report

## Technologies

- Google Cloud Platform
- Google BigQuery
- Standard SQL
- CSV

## Repository structure

```text
GCP-Sales-ETL-Pipeline/
├── data/
│   └── sales_data.csv
├── schemas/
│   └── raw_sales_schema.json
├── sql/
│   ├── 00_create_dataset.sql
│   ├── 01_transform_sales.sql
│   ├── 02_sales_report.sql
│   └── 03_validation.sql
├── README.md
└── .gitignore
```

Screenshots are intentionally not included in this starter package. Add your own actual BigQuery screenshots to a `screenshots/` folder after completing the implementation.

## Data warehouse design

### 1. Raw table: `sales_dw.raw_sales`

Stores the original CSV records without transformation.

| Column | BigQuery type | Description |
|---|---|---|
| sale_id | INT64 | Transaction identifier |
| product_id | INT64 | Product identifier |
| sale_date | DATE | Date of transaction |
| quantity | INT64 | Units sold |
| amount | NUMERIC | Transaction amount |

### 2. Product dimension: `sales_dw.dim_product`

| Column | BigQuery type | Description |
|---|---|---|
| product_id | INT64 | Unique product identifier |

The source CSV contains product IDs but no product names or descriptions, so this dimension uses the available product identifier only.

### 3. Sales fact: `sales_dw.fact_sales`

| Column | BigQuery type | Description |
|---|---|---|
| sale_id | INT64 | Transaction identifier |
| product_id | INT64 | Product reference |
| sale_date | DATE | Date of transaction |
| quantity | INT64 | Units sold |
| sales_amount | NUMERIC | Positive transaction amount |

`dim_product.product_id` is the dimension key referenced by `fact_sales.product_id`. One product can be associated with many sales transactions.

## Setup and execution

1. Sign in to Google Cloud Console and open BigQuery Studio.
2. Select your Google Cloud project. The BigQuery Sandbox can be used for this small exercise if available.
3. Open `sql/00_create_dataset.sql` and run it to create the `sales_dw` dataset. The script uses the `asia-south1` region; change it if you select a different region.
4. In BigQuery, select the `sales_dw` dataset and choose **Create table**.
5. Set the source to **Upload**, select `data/sales_data.csv`, and choose CSV as the file format.
6. Set the destination table to `raw_sales`.
7. Under schema, select **Edit as text** and paste the contents of `schemas/raw_sales_schema.json`.
8. Set **Header rows to skip** to `1`, then create the table.
9. Open and run `sql/01_transform_sales.sql`.
10. Open and run `sql/02_sales_report.sql` to view the final aggregated report.
11. Run `sql/03_validation.sql` to check the row counts and totals.

All scripts assume the dataset is named `sales_dw` in the currently selected Google Cloud project. The source table must be named `raw_sales`.

## Transformation logic

- Extract: load the CSV into `sales_dw.raw_sales`.
- Transform: select distinct product IDs for the dimension.
- Transform: retain only rows where `amount > 0` for the fact table.
- Load: create or replace the dimension and fact tables.
- Report: join the fact and dimension tables and aggregate quantity, transaction count, and sales amount by product.

The SQL scripts use `CREATE OR REPLACE TABLE`, so rerunning the transformation refreshes the two warehouse tables from the raw table.

## Expected results for the supplied CSV

| Metric | Expected result |
|---|---:|
| Raw records | 20 |
| Unique products in dimension | 10 |
| Positive-value fact records | 18 |
| Zero-dollar records in fact table | 0 |
| Products appearing in final report | 9 |
| Total quantity sold | 34 |
| Total sales revenue | 17,600 |

Product 105 remains in the Product dimension because it exists in the source data, but it does not appear in the sales report because its transactions have zero-dollar amounts only.

## Screenshots for assignment submission

After running the project, create a `screenshots/` folder and add your own screenshots:

- `01_etl_configuration.png` — CSV upload configuration, destination table and schema.
- `02_successful_execution.png` — successful BigQuery transformation job and created tables.
- `03_final_sales_report.png` — final query and aggregated result rows.

Do not use example screenshots from the internet; capture the actual results from your own BigQuery account.

## Notes

- The CSV is included in this repository to make the exercise reproducible. Confirm you are allowed to publish the dataset before making the repository public.
- Never commit passwords, service-account keys, API tokens, or other credentials.
- This repository contains SQL-based BigQuery ETL scripts. The CSV-to-BigQuery initial load is performed through the BigQuery Console UI as described above.
