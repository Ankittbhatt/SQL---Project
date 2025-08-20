

--============================
-- Ranking Analaysis
--============================




-- What are the 5 Products who generate the highest revenue


WITH CTE1 AS
(
SELECT 
	Product_name,
	SUM(sales_amount) [totalsales],
	DENSE_RANK() OVER(ORDER BY SUM(sales_amount) DESC) AS [rank1]
FROM gold.dim_products AS t1
LEFT JOIN gold.fact_sales AS t2
ON t1.product_key = t2.product_key
GROUP BY Product_name
)

SELECT 
	Product_name,
	totalsales
FROM CTE1 WHERE rank1 <=5


-- What are the 5 worst-performing products in terms of sales

WITH CTE2 AS
(
SELECT 
	Product_name,
	COALESCE(SUM(sales_amount),0) [totalsales],
	DENSE_RANK() OVER(ORDER BY COALESCE(SUM(sales_amount),0) ASC) AS [rank1]
FROM gold.dim_products AS t1
LEFT JOIN gold.fact_sales AS t2
ON t1.product_key = t2.product_key
GROUP BY Product_name
)
SELECT 
	Product_name,
	totalsales
FROM CTE2 WHERE rank1 <=5;


-- wHAT ARE THE TOP 10 CUSTOMERS WHO HAVE GENERATED THE HIGHEST REVENUE

WITH CTE3 AS
(
SELECT 
	t1.customer_key,
	t1.customer_id,
	 CONCAT(t1.first_name,' ',t1.last_name) AS [CustomerName],
	SUM(t2.sales_amount) AS [TotalSales],
	DENSE_RANK() OVER(ORDER BY SUM(t2.sales_amount) DESC) AS [RANK1]
FROM gold.dim_customers AS t1
LEFT JOIN gold.fact_sales AS t2
ON t1.customer_key = t2.customer_key
GROUP BY t1.customer_key,
		 t1.customer_id,
		 CONCAT(t1.first_name,' ',t1.last_name)
)
SELECT customer_key,CustomerName FROM CTE3 WHERE Rank1<=10;