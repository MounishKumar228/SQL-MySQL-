use salesdb;
-- Database Architecture: Physical level, Logical level, View level
-- Physical level(Internal layer): Actual data is storedin physical storage
-- Database Administrator works in this layer, (Datafiles, Partituions, Logs, Blocks, Caches)
-- Logical level(Conceptual): Appli dev (data  eng) Stuctures the data, Tables, Relationships, Views, Indexes, Procedures
-- View level(External: Users(Business Analytics, Power BI, End users)
-- 3absractions lecels of the databases
-- View: Virtual table on the the result set of a query, without storing the data in database
-- Generally SQL Queries
-- Central Query Logic: Store central , complex query logic inthe database for access by multiple queries
-- reducing project complexity(Storedin databse -> All analysts can use it to reduce the queries)
-- Find the running total sales of each month
with CTE_monthly_summary as(
select
month(orderdate) ordermonth,
sum(sales) totalsales,
count(orderid) totalorders,
sum(quantity) totalquantity
from orders
group by month(orderdate))
select
ordermonth,
totalsales,
sum(totalsales) over(order by ordermonth) as RunningTotal
from CTE_monthly_summary;

create view salesdb.v_monthly_summary as(
select
month(orderdate) ordermonth,
sum(sales) totalsales,
count(orderid) totalorders,
sum(quantity) totalquantity
from orders
group by month(orderdate));
select
*
from v_monthly_summary;
select
ordermonth,
totalsales,
sum(totalsales) over(order by ordermonth) as RunningTotal
from v_monthly_summary;
-- T-SQL: Transact SQL is an extension of SQL that adds programming features
-- Use case: Hide Complexity
-- Provide a view that combines the deytails from orders, products, customers and employees
create view v_order_details as(
	select
	o.orderid,
	concat(coalesce(c.firstname,''), " ",coalesce(c.lastname,'')) customername,
	concat(coalesce(e.firstname,''), " ",coalesce(e.lastname,'')) employeename,
	e.department,
	c.country customercountry,
	p.product,
	p.category,
	o.orderdate,
	o.quantity,
	o.sales
	from orders o
	left join products p on o.productid = p.productid
	left join customers c on o.customerid = c.customerid
	left join employees e on o.salespersonid = e.employeeid);
select
*
from v_order_details;

-- Usecase: Data Security
-- Provide a view for EU sales teamthat  commbines details from all tables
-- and excludes data related to the USA
create view v_GER_Ord_details as(
select
	o.orderid,
	concat(coalesce(c.firstname,''), " ",coalesce(c.lastname,'')) customername,
	concat(coalesce(e.firstname,''), " ",coalesce(e.lastname,'')) employeename,
	e.department,
	c.country customercountry,
	p.product,
	p.category,
	o.orderdate,
	o.quantity,
	o.sales
	from orders o
	left join products p on o.productid = p.productid
	left join customers c on o.customerid = c.customerid
	left join employees e on o.salespersonid = e.employeeid
    where c.country != 'USA'
    );
select
*
from v_GER_Ord_details;
-- Use Case: Flexibility & Dynamic
-- Usecase: Multi - Languages
-- Use Case: Virtual Marts in Data Warehouse
































