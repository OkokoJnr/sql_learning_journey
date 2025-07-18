-- Connect to the default database (if not already connected)
--\c postgres

-- Drop the 'MyDatabase' database if it exists and then create it.
DROP DATABASE IF EXISTS "MyDatabase"
CREATE DATABASE "MyDatabase";

-- Now connect to the new database.
--\c "MyDatabase"

-- ======================================================
-- Table: customers
-- ======================================================
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    country VARCHAR(50),
    score INT,
    CONSTRAINT pk_customers PRIMARY KEY (id)
);

SELECT * FROM customers
-- Insert customers data
INSERT INTO customers (id, first_name, country, score) VALUES
    (1, 'Maria', 'Germany', 350),
    (2, ' John', 'USA', 900),
    (3, 'Georg', 'UK', 750),
    (4, 'Martin', 'Germany', 500),
    (5, 'Peter', 'USA', 0);

-- ======================================================
-- Table: orders
-- ======================================================
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_date DATE,
    sales INT,
    CONSTRAINT pk_orders PRIMARY KEY (order_id)
);

-- Insert orders data
INSERT INTO orders (order_id, customer_id, order_date, sales) VALUES
    (111, 1, '2021-01-11', 32),
    (1121, 3, '2021-06-18', 67),
    (1421, 22, '2021-06-18', 53),
    (3121, 23, '2021-06-18', 63),
    (10021, 2, '2021-06-18', 43),
    (1211, 6, '2021-08-31', 58);


INSERT INTO orders(order_id, customer_id,  sales) VALUES(
    1101, 23, 45
)

SELECT coalesce(order_date, '2024--12-01') FROM orders

SELECT 
score,
    CASE
    WHEN score < 400 THEN 'Low'
    WHEN score < 600 THEN 'Medium'
    ELSE 'Very High'
    END
 FROM customers
 
SELECT 
    CASE 
        WHEN sales < 20 THEN 'Low'
        WHEN sales < 30 THEN 'Medium'
        WHEN sales >30 THEN 'High'
    END as category,
    SUM( sales) AS total_sales
 FROM orders
 GROUP BY category
 ORDER BY total_sales DESC




SELECT 
    customer_id,
    COUNT(order_id)
FROM orders
WHERE sales > 30
GROUP BY customer_id
ORDER BY customer_id


SELECT 
    customer_id,
    SUM(CASE
        WHEN sales > 30 THEN 1
        ELSE 0
        END ) AS countHighSales,
        COUNT(*)
FROM 
    orders
GROUP BY customer_id


SELECT 
order_id,
customer_id,
sales,
SUM(sales) OVER()
 FROM orders

--Total Sales for EAch product and provide other details like other id, order date
 SELECT
 productid,
 orderstatus
 orderid,
 orderdate,
 sales,
 SUM(sales) OVER() TotalSales,
 SUM(sales) OVER(PARTITION BY productid),
 SUM(sales) OVER(PARTITION BY productid, orderstatus) TotalSalesByProduct
 FROM sales.orders

 select orderstatus, productid,
 SUM(sales) over(PARTITION BY orderstatus)
 from sales.orders

--Rank other base on sales
SELECT 
    orderid,
    orderstatus,
    orderdate,
    Sales,
    Rank() OVER(PARTITION BY orderstatus ORDER BY sales DESC) AS sales_rank
FROM
sales.orders

--WINDOW FRAME
SELECT 
    productid,
    sales ,
    orderstatus,
    SUM(sales) OVER() total_sales,
    SUM(sales) OVER(
        PARTITION BY productid 
        ORDER BY orderdate 
        ROWS BETWEEN UNBOUNDED PRECEDING AND 3 FOLLOWING) total_salesROWS
FROM sales.orders

SELECT 
  productid,
  sales,
  SUM(sales) OVER (
    PARTITION BY productid 
    ORDER BY orderdate
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_total
FROM sales.orders;



SELECT
productid,
orderid,
customerid,
sales,
--SUM(sales) OVER() as total_sum,
--SUM(Sales) OVER(ORDER BY orderid ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_1,
--SUM(sales) OVER(ORDER BY orderid ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_last,

SUM(sales) OVER( ORDER BY orderid ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) as sum_sum,
SUM(sales) OVER( ORDER BY productid ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) as sum_sum
FROM sales.orders

SELECT
  orderid,
  productid,
  customerid,
  sales,
  SUM(sales) OVER() AS total_sum,
  SUM(sales) OVER(ORDER BY orderid ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS full_window_sum,
  SUM(sales) OVER(ORDER BY orderid ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
  SUM(sales) OVER(PARTITION BY productid ORDER BY orderid ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS moving_sum
FROM sales.orders;


--Rank customers base on their total sales
SELECT customerid, c2.first_name, c2.last_name, c1.customer_tot_sales, c1.sales_rank FROM ( SELECT 
 customerid,
 rank() OVER(ORDER BY SUM(sales) DESC) AS sales_rank,
 SUM(sales) AS customer_tot_sales
 FROM sales.orders
 GROUP BY customerid
 ) as c1
 LEFT JOIN customers as c2
 ON c1.customerid = c2.id
ORDER BY sales_rank

--checking for duplicates
SELECT
* from sales.ordersarchive

SELECT orderid, COUNT(orderid) FROM sales.ordersarchive
GROUP BY orderid
HAVING COUNT(orderid) > 1;
 --HAVING COUNT(*) > 1);

 SELECT orderid, count(*) OVER(PARTITION BY orderid) AS order_count
  FROM sales.ordersarchive

  --All orders wheresales are higher than the average sales across all orders

SELECT * FROM (
      SELECT 
  order_id,
  sales,
  AVG(sales) OVER() avg_sales
  FROM orders
)t

where sales > avg_sales


--window_Rank

SELECT 
    order_id oid,
    sales,
    ROW_NUMBER() OVER(ORDER BY sales) sales_rn,
    RANK() OVER(order by sales) sales_rank,
    DENSE_RANK() OVER(order by sales) sales_dense_rank
    
 FROM orders

--TOP-N- ANALYSIS: top highest sales per product

SELECT * 
FROM (
    SELECT 
    productid,
    sales,
    ROW_NUMBER() OVER(PARTITION BY productid ORDER BY sales DESC) sales_rank
FROM
sales.ordersarchive
)t

--BOTTOM-N-ANALYSIS: find the lowest two customers base on their total sales

-- SELECT * FROM (
--     SELECT 
--     customer_id,
--     sales,
--     SUM(sales) OVER(PARTITION BY customer_id) total_sales
-- FROM 
--     orders
-- ) t
-- ORDER BY total_sales ASC
-- LIMIT 2;

SELECT * FROM (
    SELECT 
    customer_id,
    SUM(sales) total_sales,
    ROW_NUMBER() OVER(ORDER BY SUM(sales) ASC) customers_Rank
FROM
    orders
GROUP BY customer_id
) t
WHERE customers_Rank <= 2

-- select 
--     ROW_NUMBER() OVER(),
--     customer_id, 
--     sales,
--     SUM(sales) OVER() so,
--     SUM(sales) OVER(PARTITION BY customer_id) sop,
--     SUM(sales) OVER(PARTITION BY customer_id ORDER BY customer_id DESC) total_sales_date
-- from orders

--Assigning Unique IDs to the rows of tables

SELECT
    *,
    ROW_NUMBER() OVER(ORDER BY orderid, orderdate) uniqueID
FROM
    sales.ordersarchive

--Identifying Duplicates and Reoving Them
SELECT *
FROM (SELECT
    orderid, 
    sales,
    creationTime,
    ROW_NUMBER() OVER(PARTITION BY orderid ORDER BY creationTime DESC) rn
FROM
    sales.ordersarchive
)t

WHERE rn > 1


--Ntile and its usecase; segmenting data and exporting dataset in batches
SELECT *,
 CASE
        WHEN threebkt = 1 THEN 'High'
        WHEN threebkt = 2 THEN 'Medium'
        WHEN threebkt = 1 THEN 'Low'
        ELSE 'unknown'
    END
FROM (SELECT 
    orderid,
    sales,
    NTILE(3) OVER(ORDER BY sales DESC) AS threebkt
FROM sales.orders
) t


--cum_dist and per_rank
--products that falls within 40% of the price

SELECT * FROM
(
    SELECT 
    product,
    price,
    CONCAT(CUME_DIST() OVER(ORDER BY price) * 100, '%') AS dist_Rank_percenatge,
    CONCAT(PERCENT_RANK() OVER(ORDER BY price) * 100, '%') per_rank_percenatge, 
    PERCENT_RANK() OVER(ORDER BY price) percent_Rank,
    CUME_DIST() OVER(ORDER BY price) dist_Rank
 FROM sales.products
)t


---LAG AND LEAD
SELECT 
    order_id,
    sales,
    LAG(sales) OVER(ORDER BY sales ASC) prevSales,
    LEAD(sales) OVER(ORDER BY sales ) nxtSales
 FROM orders

 --analyze the month-over-month performance by fidning the percentage change in sales between the current and previous month

SELECT 
    *,
    ( LAG(monthly_sales) OVER (ORDER BY other_date)- (CAST(monthly_sales AS float))/LAG(monthly_sales) OVER (ORDER BY other_date))
FROM
(SELECT
    EXTRACT(MONTH from order_date) months,
    SUM(sales) monthly_sales
FROM orders
WHERE EXTRACT(MONTH from order_date) IS NOT NULL
GROUP BY months
) t

SELECT DATE_PART('month', order_date) AS order_month
FROM orders;


--extarcting month name from date
SELECT
    --order_id,
    TO_CHAR(order_date, 'Month') AS order_month_name,
    order_date,
    sales,
    LAG(sales) OVER(ORDER BY TO_CHAR(order_date, 'Month') DESC )
FROM orders;

--highest and lowest sales for each product
SELECT
    productid,
    sales,
    --MAX(sales) OVER(PARTITION BY productid ORDER BY sales DESC) HighestSales,
    --MIN(sales) OVER(PARTITION BY productid ORDER BY sales DESC) LowestSalest,
    FIRST_VALUE(sales) OVER(PARTITION BY productid ORDER BY sales DESC) as Higest1,

    LAST_VALUE(sales) OVER(PARTITION BY productid ORDER BY sales DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) as lowest1
FROM
    sales.ordersarchive


    --find the products that has a price higher than the average price of all products
SELECT * FROM(
        SELECT
    productid,
    sales,
    AVG(sales) OVER() avg_sales
    FROM 
        sales.ordersarchive
) t

WHERE sales > avg_sales

SELECT
    productid,
    sales
FROM 
    sales.ordersarchive

--rank customers base on their total sales
--Which of this is prefarable regarding optimization and performance
SELECT 
    customerid,
    SUM(sales) total_sales,
    RANK() OVER(ORDER BY SUM(sales) DESC)
FROM 
    sales.orders
GROUP BY customerid

SELECT
    *,
    RANK() OVER(ORDER BY total_sales DESC)
FROM
    (SELECT 
        customerid,
        SUM(sales) total_sales
    FROM 
        sales.orders
    GROUP BY customerid) t

--product details and total orders
SELECT * FROM sales.products
SELECT 
    productid,
    product,
    price,
    (
        SELECT
            count(orderid) 
        
        FROM 
            sales.orders
        ) total_orders
FROM
    sales.products

--determine customers details and total orders of each customer
SELECT 
    c.customerid,
    c.firstname,
    c.country,
    o.total_orders
FROM
sales.customers as c 
LEFT JOIN (
    SELECT
    customerid,
    COUNT(*) total_orders
FROM
    sales.orders
GROUP BY customerid
) o
ON o.customerid = c.customerid

---customers who placed an order
SELECT 
    c.customerid,
    c.firstname,
    c.country
FROM
sales.customers as c 
WHERE c.customerid IN (SELECT customerid FROM sales.orders)

SELECT * from sales.products
WHERE price >= (SELECT AVG(price) FROM sales.products)