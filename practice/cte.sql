--Total sales for each customers
WITH cte_total_sales AS (
    SELECT
        customerid,
        SUM(sales) AS total_sales
    FROM sales.orders
    GROUP BY customerid
)

--Last Order date of each customers
,cte_last_order_date AS (
    SELECT 
        customerid,
        MAX(orderdate) last_order_date
    FROM 
        sales.orders
    GROUP BY customerid
    )


--Main Query
SELECT 
    c.customerid,
    c.firstname,
    cte_ts.total_sales,
    cte_lod.last_order_date,
    cte_rc.customers_rank
FROM 
    sales.customers c
LEFT JOIN cte_total_sales cte_ts
ON c.customerid = cte_ts.customerid
LEFT JOIN cte_last_order_date cte_lod
ON c.customerid = cte_lod.customerid

