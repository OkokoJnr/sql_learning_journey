SELECT * 
FROM sales.orders o
where o.customerid in (SELECT customerid FROM sales.customers
where country != 'Germany');

select * from sales.employees
where gender = 'F' and salary > all(
	select salary 
	from sales.employees 
	where gender = 'M')

SELECT
	c.customerid,
	firstname,
	(
		select 
		count(orderid) as total_orders 
		from sales.orders as o
		where c.customerid = o.customerid)
FROM 
sales.customers c;
SELECT 
	*
FROM sales.orders
GROUP BY customerid
--ORDERS MADE BY CUSTOMERS IN GERMANY
SELECT * 
FROM
	sales.orders o
WHERE EXISTS (
	SELECT *
FROM
	sales.customers c
WHERE country = 'Germany' AND o.customerid = c.customerid
)
