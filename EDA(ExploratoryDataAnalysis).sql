

--=======================================
-- Explore All Object in the Database
--=======================================


SELECT * FROM INFORMATION_SCHEMA.tables;
 

--======================================
-- Explore All Columns in the Database
--======================================

SELECT * FROM INFORMATION_SCHEMA.COLUMNS;



-- ===================
--  Explore Dimension 
-- ===================

-- Explore All Countries Our customers Come from


SELECT DISTINCT country FROM gold.dim_customers;


-- Explore All Categories "The major Divisions"


SELECT category,subcategory,product_name
FROM (
	SELECT DISTINCT category,subcategory,product_name,
		   CASE WHEN Category IS NULL THEN 1
				ELSE 0
		   END AS ORDER1 
	FROM gold.dim_products
) t
ORDER BY order1


-- ===================
--  Explore DATE 
-- ===================


-- Find the date of first and last order
-- How many year of sales are available

SELECT 
	MIN(order_date) AS first_order,
	MAX(order_date) AS Last_order,
	DATEDIFF(year,MIN(order_date),MAX(order_date)) AS order_range_years
FROM gold.fact_sales;



-- Find the youngest and oldest customers


SELECT
	MIN(birthdate) AS oldest_birthdate,
	DATEDIFF(year,MIN(birthdate),getdate()) AS Oldest_age,
	MAX(birthdate) AS Youngest_birthdate,
	DATEDIFF(year,MAX(birthdate),GETDATE()) AS Youngest_age
FROM gold.dim_customers;




-- ===================
--  Exploring Measures
-- ===================


-- Find the total sales
SELECT SUM(sales_amount) AS total_Sales FROM gold.fact_sales

-- find total sales for each product

SELECT
	product_name,
	SUM(sales_amount) AS total_sales
FROM gold.dim_products AS t1
LEFT JOIN 
gold.fact_sales AS t2
ON t1.product_key = t2.product_key
GROUP BY product_name
ORDER BY total_sales DESC

-- Product With Zero sales

SELECT 
	Product_name
FROM(
SELECT
	product_name,
	SUM(sales_amount) AS total_sales
FROM gold.dim_products AS t1
LEFT JOIN 
gold.fact_sales AS t2
ON t1.product_key = t2.product_key
GROUP BY product_name ) t
WHERE total_sales is null


-- Find how many items are sold

SELECT SUM(quantity) AS total_items_Sold FROM gold.fact_sales;


-- Find the average selling price

SELECT AVG(sales_amount) AS Average_Selling_Amount FROM gold.fact_sales

-- Find the total number of orders

SELECT COUNT(DISTINCT order_number) AS total_no_of_orders FROM gold.fact_sales;

-- Find the total number of products

SELECT COUNT(DISTINCT product_name) AS Total_Products FROM gold.dim_products;

-- Find the total number of customers

SELECT COUNT(DISTINCT customer_id) FROM gold.dim_customers;


-- Find the total number of customers that has placed an order

SELECT COUNT(customer_id) AS total_no_of_customer_placed_order FROM gold.dim_customers AS C
WHERE EXISTS 
( SELECT 1 FROM gold.fact_sales AS s 
WHERE c.customer_key = s.customer_key)



-- ========================================================
--  Generate Report That shows all Key Metrics Of buisness
-- ========================================================



SELECT 'Total_Sales' AS Measure_Name ,SUM(sales_amount) AS Measure_Value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS Measure_Name ,SUM(quantity) AS Measure_Value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' AS Measure_Name ,AVG(price) AS Measure_Value FROM gold.fact_sales
UNION ALL
SELECT 'Total_No_Of_Orders' AS Measure_Name ,COUNT(DISTINCT order_number) AS Measure_Value FROM gold.fact_sales
UNION ALL
SELECT 'Total_No_Of_Producs' AS Measure_Name ,COUNT(product_name) AS Measure_Value FROM gold.dim_products
UNION ALL
SELECT 'Total_No_Of_Customers' AS Measure_Name ,COUNT(customer_key) AS Measure_Value FROM gold.dim_customers