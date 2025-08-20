
/*

======================================================================
customer Report
======================================================================

Purpose:
	- This report consolidate key customer metrics and behaviours

Highlights:
	1. Gather essential fiels such as product name,age and transaction details
	2. segments customers into categories (VIP,Regular,New) and age groups
	3. Aggregated customer-level metrics:
		- total orders
		- total sales
		- total quantity purchases
		- total products
		- lifespan (in month)
	4. Calculates valuable KPIs:
		- recency (month since last sale)
		- average order value
		- average monthly spend
==============================================================================
*/




CREATE VIEW gold.customer_report AS 
WITH Customer_details AS
/* ---------------------------------------------------------
1) Base Query : Retrives core columns from tables
-------------------------------------------------------------*/
(
SELECT 
	t2.customer_key,
	t2.customer_id,
	CONCAT(t2.first_name,' ',t2.last_name) AS Full_Name,
	DATEDIFF(YEAR,t2.birthdate,GETDATE()) AS Age,
	t1.order_number,
	t1.product_key,
	t1.order_date,
	t1.sales_amount,
	t1.quantity
FROM gold.fact_sales AS t1
LEFT JOIN gold.dim_customers AS t2
ON t1.customer_key = t2.customer_key
WHERE order_date IS NOT NULL
),
customer_agg
/* ---------------------------------------------------------
2) Customer Aggregations : Summarzes key metrics at the customer level
-------------------------------------------------------------*/
AS
(
SELECT 
	customer_key,
	customer_id,
	Full_Name,
	age,
	COUNT(DISTINCT order_number) AS Total_Orders,
	SUM(sales_amount) AS Total_Sales,
	SUM(quantity) AS Total_Quantity,
	COUNT(DISTINCT product_key) AS TotalProducts,
	MIN(order_date) AS First_Order,
	MAX(order_date) AS Last_Order,
	DATEDIFF(MONTH,MIN(order_date),MAX(Order_date)) AS Lifespan
FROM customer_details
GROUP BY customer_key,
		 customer_id,
		 Full_Name,
		 age
)

/* ---------------------------------------------------------
3) Final Query
-------------------------------------------------------------*/

SELECT
	customer_key,
	customer_id,
	Full_Name,
	age,
    Total_Orders,
	Total_Sales,
	Total_Quantity,
	TotalProducts,
	First_Order,
	Last_Order,
	Lifespan,
	CASE WHEN Total_sales > 5000 AND lifespan > 12 THEN  'VIP'
	     WHEN Total_Sales <= 5000 AND lifespan > 12 THEN 'Regular'
		 ELSE 'New'
	END AS Customer_segment,
	CASE WHEN age < 18 THEN 'Under 18'
	     WHEN age BETWEEN 18 AND 30 THEN '18-30'
		 WHEN age BETWEEN 31 AND 50 THEN '31-50'
		 ELSE 'Above 50'
	END AS Age_Group ,
	DATEDIFF(MONTH,last_order,GETDATE()) AS Recency,
	-- Compute AverageOrderValue(AVO)
	CASE WHEN Total_orders = 0 THEN 0
	     else Total_Sales/Total_orders 
	END AS AvgOrderValue,
	-- Compute Average Monthly Spending
	CASE WHEN Lifespan = 0 Then Total_sales
		 ELSE Total_sales/Lifespan
	END AS AverageMonthlySpending
FROM customer_agg


-- Selected Report From View

SELECT * FROM gold.customer_report





