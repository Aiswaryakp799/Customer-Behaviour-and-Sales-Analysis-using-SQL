CREATE DATABASE customer_revenueinsights;
USE customer_revenueinsights;
SELECT * FROM customer_revenueinsights.customer_revenue_table;
-- Remove NULL CustomerID's
DELETE FROM customer_revenue_table 
WHERE CustomerID IS NULL;
-- remove negative or zero quantity
DELETE FROM customer_revenue_table 
WHERE Quantity <= 0;
-- remove invalid prices
DELETE FROM customer_revenue_table
WHERE UnitPrice <= 0;
-- creating revenue column
SELECT *,
       (Quantity * UnitPrice) AS Revenue
FROM customer_revenue_table;
-- calculating total revenue
SELECT SUM(Quantity * UnitPrice) AS total_revenue
FROM customer_revenue_table;
-- changing date format
ALTER TABLE customer_revenue_table
ADD COLUMN InvoiceDate_new DATETIME;
UPDATE customer_revenue_table
SET InvoiceDate_new = STR_TO_DATE(InvoiceDate, '%d-%m-%Y %H:%i');
-- monthly revenue
SELECT 
    DATE_FORMAT(InvoiceDate_new, '%Y-%m') AS Month,
    SUM(Quantity * UnitPrice) AS Revenue
FROM customer_revenue_table
GROUP BY Month
ORDER BY Month;
-- top products
SELECT Description,
       SUM(Quantity * UnitPrice) AS revenue
FROM customer_revenue_table
GROUP BY Description
ORDER BY revenue DESC
LIMIT 10;
-- top customers
SELECT CustomerID,
       SUM(Quantity * UnitPrice) AS total_spent
FROM customer_revenue_table
GROUP BY CustomerID
ORDER BY total_spent DESC
LIMIT 10;
-- country-wise sales
SELECT Country,
       SUM(Quantity * UnitPrice) AS revenue
FROM customer_revenue_table
GROUP BY Country
ORDER BY revenue DESC;
-- repeat customers
SELECT CustomerID,
       COUNT(DISTINCT InvoiceNo) AS orders
FROM customer_revenue_table
GROUP BY CustomerID
HAVING orders > 1
ORDER BY orders DESC;
-- canacelled order
SELECT *
FROM customer_revenue_table
WHERE InvoiceNo LIKE 'C%';
