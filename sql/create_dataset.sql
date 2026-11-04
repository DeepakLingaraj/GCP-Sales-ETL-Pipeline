-- Create the BigQuery dataset.
-- Run this in the project selected in BigQuery Studio.
-- Change the location if you prefer another BigQuery region.

CREATE SCHEMA IF NOT EXISTS `sales_dw`
OPTIONS(location = 'asia-south1');
