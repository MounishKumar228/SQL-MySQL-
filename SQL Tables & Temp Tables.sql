use salesdb;
-- Table : A structured collection of data. 
-- Types: Permananent, Temporary
-- Permanant: CREATE/SELECT, CTAS(create tabe based on the result of the query)
-- 1. Use Case: Optimize Performance

create table num_of_orders as(
select
month(orderdate),
count(*) orders
from orders
group by month(orderdate));
select
* from num_of_orders;
drop table num_of_orders;

-- 2. Use Case: Creating a snapshot
-- 3. Physical data mart in data warehouse
-- TEMP TABLES Use Case: Immediate Results




































