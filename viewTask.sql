-- TASK: Provide view tat combines details from orders, products, customers, and employees
CREATE VIEW combine_data AS (
    SELECT * FROM sales.orders o
     LEFT JOIN sales.products p
     ON o.productid = p.productid
     LEFT JOIN sales.customerid 
     ON o.customerid = c.customerid
     LEFT JOIN employees
     ON o.salespersonid = e.employeeid
    
)