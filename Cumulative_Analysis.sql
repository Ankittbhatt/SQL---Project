


--======================
-- Cumulative Analysis
--======================

-- calculate the total sales per month 
-- and running total of sales over time


SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER(ORDER BY order_Date) AS [Running_Total_per_month]
FROM (
SELECT
	DATETRUNC(month,order_date) AS order_DATE,
	SUM(sales_amount) AS [Total_Sales]
FROM gold.fact_sales
WHERE order_Date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)) as t

-- Running total for each year

SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_Date) AS [Running_Total_per_year]
FROM (
SELECT
	DATETRUNC(YEAR,order_date) AS order_DATE,
	SUM(sales_amount) AS [Total_Sales]
FROM gold.fact_sales
WHERE order_Date IS NOT NULL
GROUP BY DATETRUNC(YEAR,order_date)) as t
