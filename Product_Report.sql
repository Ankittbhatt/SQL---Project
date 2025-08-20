
/*

======================================================================
Product Report
======================================================================

Purpose:
	- This report consolidate key Product metrics and behaviours

Highlights:
	1. Gather essential fiels such as product name,category,subcategory, and cost
	2. segments products by revenue to identify High-Performers,Mid-Range,or Low-Performers.
	3. Aggregated Product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers(UNIQUE)
		- lifespan (in month)
	4. Calculates valuable KPIs:
		- recency (month since last sale)
		- average order revenue
		- average monthly revenue
==============================================================================
*/


CREATE VIEW gold.product_report AS 
WITH product_details AS

/* ---------------------------------------------------------
1) Base Query : Retrives core columns from tables
-------------------------------------------------------------*/
(
SELECT 
	t2.product_key,
	t2.category,
	t2.subcategory,
	t2.product_name,
	t2.cost,
	t1.order_number,
	t1.customer_key,
	t1.order_Date,
	t1.sales_amount,
	t1.quantity
FROM gold.fact_sales AS t1
LEFT JOIN gold.dim_products AS t2
ON t2.product_key = t1.product_key
WHERE order_Date IS NOT NULL
),
Product_agg AS
/* ---------------------------------------------------------
2) product Aggregations : Summarzes key metrics at the product level
-------------------------------------------------------------*/
(
SELECT
	product_key,
	category,
	subcategory,
	product_name,
	SUM(sales_amount) AS Total_Sales,
	COUNT(DISTINCT order_number) AS Total_Orders,
	SUM(quantity) AS Total_Quantity_Sold,
	COUNT(DISTINCT Customer_key) AS Total_customers,
	MAX(order_date) AS Last_Order_Date,
	DATEDIFF(MONTH,MIN(order_Date),MAX(order_Date)) AS Lifespan
FROM product_details
GROUP BY product_key,
		 category,
		 subcategory,
		 product_name
)



/* ---------------------------------------------------------
3) Final Query
-------------------------------------------------------------*/


SELECT
	product_key,
	category,
	subcategory,
	product_name,
	Total_Sales,
	Total_Orders,
	Total_Quantity_Sold,
	Total_customers,
	Last_Order_Date,
	DATEDIFF(MONTH,Last_Order_Date,GETDATE()) AS Recency,
	Lifespan,
	CASE WHEN total_sales > 50000 THEN 'High-Performer'
	     WHEN total_sales >= 10000 THEN 'Mid-Performer'
		 ELSE 'Low-Performer'
	END AS 'Product_segment',
	-- Average Order Revenue
	CASE WHEN total_orders = 0 THEN 0
	     ELSE total_sales/total_orders
	END AS Average_Order_Revenue,
	-- Compute Average monthly Revenue
	CASE WHEN LIFESPAN = 0 THEN total_sales
	     ELSE total_sales/lifespan
	END AS AverageMonthlyRevenue
FROM Product_agg
	

-- Selected Report From View

SELECT * FROM gold.product_report



