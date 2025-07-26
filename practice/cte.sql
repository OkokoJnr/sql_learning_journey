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

--Rank customers base on total sales per customers
,cte_rank_customers AS (
    SELECT
        customerid,
        total_sales,
        RANK() OVER (ORDER BY total_sales DESC) AS customers_rank
    FROM cte_total_sales
)

--segment customers
, cte_segment_customers AS (
    SELECT
        customerid,
        total_sales,
        CASE
            WHEN total_sales >= 100 THEN 'High'
            WHEN total_sales >= 50 THEN 'Medium'
            ELSE 'Low'
        END category
    FROM
        cte_total_sales
)
--Main Query
SELECT 
    c.customerid,
    c.firstname,
    cte_ts.total_sales,
    cte_lod.last_order_date,
    cte_rc.customers_rank,
    cte_sc.category
FROM 
    sales.customers c
LEFT JOIN cte_total_sales cte_ts
ON c.customerid = cte_ts.customerid
LEFT JOIN cte_last_order_date cte_lod
ON c.customerid = cte_lod.customerid
LEFT JOIN cte_rank_customers cte_rc
ON c.customerid = cte_rc.customerid
LEFT JOIN cte_segment_customers cte_sc
ON c.customerid = cte_sc.customerid

--Recursive CTE
--Generate sequence of 20 numbers

WITH RECURSIVE cte_sequence20 AS (
    --Anchor query
    SELECT 0 AS myNum
    UNION ALL 
    --Recursive query
    SELECT 
        myNum + 2
    FROM
        cte_sequence20
    WHERE myNum < 20
) 

SELECT * FROM cte_sequence20

--show the employee hierarchy by displaying eac employee's level within the organization


WITH RECURSIVE cte_org_hierarchy AS(
    SELECT 
        employeeid,
        firstname,
        managerid,
        1 as level
    FROM
        sales.employees
        WHERE managerid IS NULL
    
    UNION ALL
    SELECT
        e.employeeid,
        e.firstname,
        e.managerid,
    level + 1
    FROM sales.Employees AS e
    INNER JOIN cte_org_hierarchy cte_oh
    ON e.managerid = cte_oh.employeeid    
)
SELECT 
    *
FROM
    cte_org_hierarchy