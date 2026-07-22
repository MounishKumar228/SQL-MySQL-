use salesdb;
-- Join tables - Filtering - Transformations - Aggregations
-- Dependency: Non-correlated subquery & correlated query
-- Result types: Scalar, Row, Table subqueries
-- Location/clauses: select, from, join, where(comparision operators & Logical operators)
-- Find the products that have a price higher than the avg price of the products
select
productid,
product,
price
from(
select
productid,
product,
price,
round(avg(price) over(), 0) avgprice
from products)t where price>avgprice;
-- Rank customers based on their total sales
select
*,
dense_rank() over(order by totalsales desc) cusrank
from(
select
customerid,
sum(sales) totalsales
from orders
group by customerid)t;

-- Select subquery: used to aggregate data side by side with the main query's data 
-- allowing for direct comparision
-- only scalar subqueries are allowed

-- show the productids, names, prices and total number of orders
select
productid,
product,
price,
(select count(orderid) from orders) totalorders
from products;

-- join subquery: Used to prepare the data(filtering or aggregation) 
-- before joining it with other tables

-- Show all customer details and find the total orders of each customer
select
c.*,
o.totalorders
from customers c
left join(
	select
    customerid,
    count(*) totalorders
    from orders
    group by customerid) o  on
c.customerid = o.customerid;

-- Where subquery: Used for complex filtering logic & makes query more flexible & dynamic
-- to filter the data we use comparosion and logical operators
-- When using comparision operators only scalar subquery is allowed

-- Find the price that have a price higher than the average price of all products
select
productid,
price
from products
where price > (
	select
    avg(price) avgprice
    from products
    );
    
-- LOGICAL OPERATOR: IN
-- Show the detais of orders made by customers in germany
select
c.country,
o.*
from orders o
left join customers c on o.customerid = c.customerid
where country in (select country from customers where country = 'Germany');

select
*
from orders
where customerid in(select customerid from customers where country='Germany');

-- ANY operator: checks if any value within a list
-- used tocheck if a value is true for atleast one of the values in a list
-- Find female employees whose salaries are greater than the salaries of any male employees
select
 employeeid,
 gender,
 salary
 from employees
 where gender = 'F' and salary > any(select salary from employees where gender = 'M');
-- Find female employees whose salaries are greater than the salaries of all male employees
select
 employeeid,
 gender,
 salary
 from employees
 where gender = 'F' and salary > all(select salary from employees where gender = 'M');
 -- Non - correlated subquery: A subquery that can run independently from the main query
 -- correlated subquery: A subquery that that relays on values from the main query
 select
 *,
 (select count(*) from orders o where o.customerid = c.customerid) totalorders
 from customers c; 
 
 -- EXISTS operator
 -- Show the details of orders made by customers in germany
 select
 *
 from orders o
where exists(select
				1
                from customers c
                where country='Germany' and o.customerid = c.customerid);






























