--Retrieve all Customer Data
SELECT * 
FROM customers;

--Retrieve Some Columns: Customer's name, country and score

SELECT 
    first_name, 
    country, 
    score 
FROM customers

--WHERE: Filter Data Based on a condition 
--Customers with score not equal to zero

SELECT 
    first_name,
    country 
FROM customers
WHERE score <> 0;

--Customers from Germany
SELECT 
    first_name, 
    country 
FROM customers
WHERE country = 'Germany';

--Note: Postgress reads Double quote as identifier. They are identifiers for table and  column names. In the above using double quotes will return an error. 

--Sorting your data using ORDER BY
SELECT 
    first_name, 
    country, 
    score
FROM customers
ORDER BY country ASC, score DESC;

--GROUPING DATA
SELECT 
    country,
    COUNT(country) AS customer_count,
    SUM(score) AS total_score
FROM customers
GROUP BY country
ORDER BY total_score DESC;


--HAVING: Filter grouped data

SELECT 
    country,
    COUNT(country) AS customer_count,
    SUM(score) AS total_score   
FROM customers
GROUP BY country   
HAVING SUM(score) > 800

SELECT 
    country,
    AVG(score) AS average_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING avg(score) > 430


--DISTINCT CLAUSE: Retrieve unique values
SELECT DISTINCT country
FROM customers;


--LIMIT 
SELECT * 
FROM customers
ORDER BY score DESC;


SELECT * FROM orders LIMIT 2;

