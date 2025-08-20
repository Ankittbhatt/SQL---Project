
/* Group customers into three segments based on therie spending behavious
- VIP : Customers With at least 12 months of history and spending more than 5000,
- Regular : customers with at least 12 month of history but spending 5000 or less
- New : Customers with a lifespan less than 12 month
and find the total number of customers for each group
*/

WITH CTE1 AS
--===================================================================================================
-- Combining all necessary column from multiple tables and perfoming some calculation on top of that
--=================================================================================================
(
SELECT
	t2.customer_key,
	t2.customer_id,
	t2.customer_number,
	CONCAT(t2.first_name,' ',t2.last_name) AS Full_Name,
	t1.order_number,
	t1.order_date,
	t1.sales_amount,
	t1.quantity,
	MIN(t1.order_date) OVER(PARTITION BY t2.customer_key,t2.customer_id) AS First_order,
	MAX(t1.order_date) OVER(PARTITION BY t2.customer_key,t2.customer_id) AS Last_order
FROM gold.fact_Sales AS t1
LEFT JOIN 
gold.dim_customers AS t2
ON t1.customer_key = t2.customer_key
),
CTE2 AS
-- =======================================================
-- Finding Key Metrics For Buisnesss
-- =======================================================
(
SELECT 
	customer_key,
	customer_id,
	customer_number,
	Full_Name,
	Order_number,
	order_Date,
	sales_amount,
	first_order,
	last_order,
	DATEDIFF(MONTH,first_order,last_order) AS History,
	CASE WHEN DATEDIFF(MONTH,first_order,last_order) >= 12 AND SUM(sales_amount) OVER(PARTITION BY customer_key,customer_id) > 5000 THEN 'VIP'
		 WHEN DATEDIFF(MONTH,first_order,last_order) >= 12 AND SUM(sales_amount) OVER(PARTITION BY customer_key,customer_id) <= 5000 THEN 'Regular'
		 ELSE 'New'
	END AS Customer_Segment
FROM CTE1
	
)

--========================================================================
-- Final Query : Grouping up on the basis of calculated customer segment
-- =======================================================================

SELECT Customer_Segment,
	   COUNT(DISTINCT customer_key) AS Total_No_Of_Customers,
	   SUM( COUNT(DISTINCT customer_key)) OVER() AS Total_Customers
FROM CTE2
GROUP BY customer_segment





