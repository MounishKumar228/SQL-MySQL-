/*
Database Creation and Table Setup Script
Script Purpose:
    This script creates a new MySQL database named 'MyDatabase'. 
    If the database already exists, it is dropped to ensure a clean setup. 
    The script then creates two tables: 'customers' and 'orders'
    with their respective schemas, and populates them with sample data.
    
*/
USE mydatabase;

-- Table: customers

CREATE TABLE cus (
    id INT NOT NULL,
    first_names VARCHAR(50),
    countrys VARCHAR(50),
    scores INT,
    PRIMARY KEY (id)
);

-- Insert customers data
INSERT INTO cus (id, first_names, countrys, scores) VALUES
    (1, 'Maria', 'Germany', 350),
    (2, ' John', 'USA', 900),
    (3, 'Georg', 'UK', 750),
    (4, 'Martin', 'Germany', 500),
    (5, 'Peter', 'USA', 0);

-- Table: orders

CREATE TABLE ord(
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_dates DATE,
    saless INT,
    PRIMARY KEY (order_id)
);

-- Insert orders data
INSERT INTO ord (order_id, customer_id, order_dates, saless) VALUES
    (1001, 1, '2021-01-11', 35),
    (1002, 2, '2021-04-05', 15),
    (1003, 3, '2021-06-18', 20),
    (1004, 6, '2021-08-31', 10);

-- Retrieve all customer data
select * from cus;
select 
	first_names,
	countrys,
	scores
from cus;

-- WHERE - filters data based on a condition
-- Retrieve customers with score not equal to zero(0)
select * from cus where scores!=0;

/* Retrieve all customers and
sort the results by the highest score first */
select * 
from cus 
order by scores desc;
-- Nested sorting
select * 
from cus 
order by countrys asc,
scores desc;

-- Find Total score by country
select countrys,
sum(scores) as total_scores
from cus
group by countrys;
-- Total score and Total no. of of customers by country
select countrys,
sum(scores) as total_scores,
count(id) as total_number_of_customers
from cus
group by countrys;
/*HAVING - filters data after aggregation
WHERE - filters data before aggregation*/
select countrys,
sum(scores) as total_scores,
count(id) as total_number_of_customers
from cus
where scores>400
group by countrys
having total_scores>800;
/* Find avg score for each country
considering only customers with a score not equal to 0
and return only those countries with an avg score greater than 430*/
select countrys,
avg(scores) as Average_Scores
from cus
where scores!=0
group by countrys
having avg(scores)>430;
-- Return Unique list of countries
select distinct
	countrys
from cus;
-- Retrieve only top country
select
	countrys,
	avg(scores) as Average_Scores
from cus
where scores!=0
group by countrys
having avg(scores)>430
limit 1;
