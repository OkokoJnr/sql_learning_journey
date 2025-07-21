
CREATE VIEW sales.VIEW_monthly_summary1 AS (
       SELECT 
        EXTRACT(MONTH FROM orderdate) AS order_month,
        SUM(sales)  total_sales,
        COUNT(orderid) as total_order,
        SUM(quantity) as total_qty
    FROM 
        sales.orders
    GROUP BY EXTRACT(MONTH FROM orderdate) 
)

