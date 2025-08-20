


-- Contribution of categories to overall sales




WITH CTE1 AS

--============================================
-- List all neccessary columns togethter
--============================================
(
SELECT 
	t2.category,
	t2.product_name,
	t1.order_Date,
	t1.sales_amount,
	t1.quantity
FROM gold.fact_Sales AS t1
LEFT JOIN
gold.dim_products AS t2
ON t1.product_key = t2.product_key
), 
CTE2 AS 

--============================================
-- Find all key metrics to business
--============================================
(
SELECT category,
	   SUM(sales_amount) AS TotalSalesByProduct,
	   SUM(SUM(sales_amount)) OVER() AS [totalsales],
	   CAST(ROUND((CAST(SUM(sales_amount) AS FLOAT)/SUM(SUM(sales_amount)) OVER())*100,2) AS NVARCHAR(MAX)) + ' %' AS Contribution_To_totalsales
FROM CTE1
GROUP BY category

)



--============================================
-- Final Query
--============================================
SELECT 
	Category,
	TotalSalesByProduct,
	totalsales,
	Contribution_To_totalsales
FROM CTE2



