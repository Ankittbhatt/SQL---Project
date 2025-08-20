

-- Analyze the yearly performance of products by comparing each products sales
-- to both its average sales performance and the previous year sales


WITH CTE2 AS 
--==========================================
-- Retrive All Necessary columns for report
--===========================================
(
SELECT 
	t1.order_Date,
	t2.product_name,
	t1.sales_Amount
FROM gold.fact_sales AS t1
LEFT JOIN
gold.dim_products AS t2
ON t1.product_key = t2.product_key
WHERE order_Date IS NOT NULL
),
CTE3 AS
--===================================
-- find all key metrics for business
--====================================
(
SELECT 
	Year(order_date) as Year1,
	Product_name,
	SUM(sales_amount) AS Total_Sales,
	ISNULL(LAG(SUM(sales_amount)) OVER(PARTITION BY product_name ORDER BY Year(Order_Date)),0) AS PreviousYearSale,
	AVG(SUM(sales_amount)) OVER(PARTITION BY Product_name) AS Avg_Sales,
	SUM(sales_amount) - AVG(SUM(sales_amount)) OVER(PARTITION BY Product_name) AS Diff_avg
FROM CTE2
GROUP BY Year(order_date),
	     Product_name
)
--=============================
-- MAIN QUERY 
--=============================
SELECT 
	Year1,
	Product_name,
	Total_sales,
	PreviousYearSale,
	Avg_sales,
	Diff_avg,
	CASE WHEN Diff_Avg > 0 THEN 'Above Average'
		 WHEN Diff_Avg < 0 THEN 'Below Average'
		 ELSE 'average'
	END AS [Avg_change]
FROM CTE3
