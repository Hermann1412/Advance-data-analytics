--Which categories contribute the most to the overall sales?

WITH category_Sales AS (
	SELECT
	category,
	SUM(sales_amount) total_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
	GROUP BY category
	)
SELECT
category,
total_sales,
SUM(total_sales) OVER() overall_Sales,
CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER()) * 100,2), '%') AS percentage_of_total
FROM category_Sales
ORDER BY total_sales DESC