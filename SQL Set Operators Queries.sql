use salesdb;
select 
firstname, lastname
from customers

union

select firstname, lastname
from employees;

-- Combine the data from employees and customers into one table(UNION)
select 
firstname, lastname
from customers
union
select firstname, lastname
from employees;

-- UNIONALL
select 
firstname, lastname
from customers
union all
select firstname, lastname
from employees;

-- EXCEPT - Returns unique rows from 1st table that are not in 2nd table(Check order Ofthe table)
-- Employees who are not customers
select 
firstname, lastname
from employees
EXCEPT
select firstname, lastname
from customers;

-- INTERSECT
select 
firstname, lastname
from customers
INTERSECT
select firstname, lastname
from employees;

-- Orders data is stored in 2 different tables 
-- Combine all orders data into one report without duplicates
select 
"orders" as Sourcetable,
orderid, productid, customerid, salespersonid, orderdate, shipdate, orderstatus, shipaddress, billaddress, quantity, sales, creationtime
from orders
union
select
"orders_archive" as Sorcetable,
orderid, productid, customerid, salespersonid, orderdate, shipdate, orderstatus, shipaddress, billaddress, quantity, sales, creationtime
from orders_archive
order by orderid;