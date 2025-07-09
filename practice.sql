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




--CHAPTER 2
-- DATA DEFINITION LANGUAGE (DDL)
--Create a new table of Persons with columns: id, persona_name, birthdate, phone

CREATE TABLE persons(
    id INT NOT NULL,
    persons_name VARCHAR NOT NULL,
    birthdate DATE,
    phone VARCHAR NOT NULL,
    CONSTRAINT persons_id PRIMARY KEY (id)
)

SELECT * FROM persons
CREATE TABLE house(
    id INT NOT NULL,
    address VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    house_type VARCHAR (50),
    CONSTRAINT house_id PRIMARY KEY (id)
)

SELECT * FROM house

--add a new column to the persons table
ALTER TABLE persons
ADD  email VARCHAR(100) NOT NULL;

ALTER TABLE persons
DROP birthdate


DROP TABLE house
DROP TABLE persons

--DATA MANIPULATION LANGUAGE
--INSERT
INSERT INTO customers (id, first_name, country, score) VALUES
    (6, 'Anna', 'Germany', 600),
    (7, 'Tom', 'USA', 800);

--Create a persons
CREATE TABLE persons(
    id INT NOT NULL,
    name VARCHAR(50),
    birthDate DATE,
    phone VARCHAR(15) NOT NULL,
    CONSTRAINT persons_id PRIMARY KEY(id)
)
DROP TABLE persons
 
SELECT * FROM persons

INSERT INTO persons(id, name, birthDate, phone)
VALUES (9, 'Emmanuel', '01-12-2005', '07772298342'),
(12, 'Felicia', '05-12-2005', '08065326723'),
(10, 'John', '01-1-2005', '091664872922'),
(11, 'Clement', '06-2-2005', '0815466565')

--insert data from persons  table to customers table
INSERT INTO customers
SELECT 
    id, 
    name, 
    NULL,
    NULL 
FROM persons

SELECT * from customers


CREATE TABLE students(
    id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    birthdate DATE,
    class VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    CONSTRAINT students_id PRIMARY KEY(id)
)

drop TABLE students
INSERT INTO students(id, name, birthdate, class, email)
VALUES (1, 'Emmanuel', '2009-01-12', 'SS3', 'Emmanuel12@m.com'),
(2, 'Felicia', '2005-05-12', 'SS1', 'Felicia71@j.ng'),
(3, 'John', '2007-01-01', 'SS2', 'John17@j.ng'),
(4, 'Clement', '2012-06-02', 'SS1', 'Clement12@n.ng');

select * from students

CREATE TABLE applicants(
    id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    class VARCHAR(15) NOT NULL,
    birthdate DATE  
)

INSERT INTO applicants(id, name, class, birthdate)
VALUES (5, 'Emmanuel', 'SS3', '2009-01-12'),
(6, 'Felicia', 'SS1', '2005-05-12'),
(7, 'John', 'SS2', '2007-01-01'),
(8, 'Clement', 'SS1', '2012-06-02');



INSERT INTO students (id, name, birthdate, class, email)
SELECT 
id, name, birthdate, class, 'unknown'
 FROM applicants

SELECT * from customers WHERE country = NULL

UPDATE students
SET birthdate = '2013-05-12'
where id = 6

UPDATE customers
SET country = 'UK'
where country IS NULL

select  COUNT(id) as total_customer from customers

DELETE FROM students
WHERE id in (4,5,7);

SELECT * FROM students;

--USING TRUNCATE
TRUNCATE TABLE students;

/*INTERMEDIATE LEVEL
        FILTERING DATA
        (
        cOMPARISON OPEARTOR, LOGICAL OPERATORE, RANGE OPERATOR, MEMBERSIP OPERATOR, SEARC OPERATOR
        )
        */

SELECT * FROM customers WHERE country = 'USA' AND score > 500

SELECT * FROM customers WHERE NOT country = 'USA' OR score > 500

SELECT * from customers WHERE country like '%N%'

SELECT * FROM customers where id in (1,2,3,5,8,9)

--JOIN
-- Inner Join
SELECT * 
FROM customers AS c 
INNER JOIN orders AS o
ON c.id = o.customer_id 

--Left Join
SELECT * FROM customers as C 
LEFT JOIN orders AS o 
ON c.id = o.customer_id

--Right Join
SELECT * FROM customers as c
RIGHT JOIN orders AS O
ON c.id = o.customer_id

--Full Join
SELECT * FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id

--Anti Left Join
--Retrieve all customers that have not placed any order
SELECT * FROM customers AS c 
LEFT JOIN orders AS o 
ON c.id = o.customer_id
WHERE o.customer_id IS NULL


INSERT INTO orders(order_id, customer_id, order_date, sales)
VALUES (1015, 22, '2009-01-12', 41),
(10026, 32, '2005-05-12', 21)

--Anti Right Join
--Retrieve others without customers
SELECT * FROM customers AS c 
RIGHT JOIN orders AS o 
ON c.id = o.customer_id
WHERE c.id IS NULL