


--============================
--CHANGE-OVER-TIME ANALYSIS
--=============================

--Analyze sales performance over time



SELECT
YEAR(order_date) AS [Order_Year],
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS toal_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date is not null
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date) 

-- 

SELECT
	YEAR(Order_date) AS [Order_Year],
	DATENAME(MONTH,Order_date) AS [Month],
	SUM(sales_amount) AS total_sales_per_month,
	SUM(SUM(sales_amount)) OVER(PARTITION BY YEAR(Order_date)) AS [Total_sales_per_year]
FROM gold.fact_sales
WHERE order_Date is not null
GROUP BY YEAR(order_date),
		 DATENAME(MONTH,Order_date)
ORDER BY YEAR(order_date),
		 DATENAME(MONTH,Order_date)