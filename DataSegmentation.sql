

--===================
-- Data Segmentation
--====================



-- SEGEMENT product into cost ranges and count how many product fall into each segment 

WITH CTE1 AS
--===========
-- CTE QUERY
--===========
(
SELECT 
	product_key,
	Category,
	product_name,
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
		 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		 WHEN cost BETWEEN 501 AND 1000 THEN '501-1000'
		 ELSE 'Above 1000'
	END AS cost_range
FROM gold.dim_products

)

--==============
-- Main Query
--==============

SELECT 
	Category,
	cost_Range,
	COUNT(product_key) AS TotalNoOfProducts
FROM CTE1
GROUP BY Category,
		 cost_range
ORDER BY Category



