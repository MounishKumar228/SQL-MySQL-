-- StoredProcedure vs Python
-- Connection: network (server) connection is a disadvantage with python
-- Pre-compile: Databaseserver knows abouth the queries makes perparations like EXEC plan
-- Flexibility: Make use of various features of python
-- Version control: Better in Python
-- Complex Logic: Better in Python
/*
CREATE PROCEDURE [procedure_name] as
BEGIN
-- SQL STATEMENTS

END
EXEC [procedure_name]
*/
use salesdb;
-- Step 1: Write a Query
-- For US customers Find the total number of customers and the average score
select
	count(*) totalcustomers,
	round(avg(score),0) avgscore
from customers
where country='USA';

-- Step 2: Turning the Query into Stored Procedure
delimiter $$
CREATE PROCEDURE sp_country_avgscore()
BEGIN
select
	count(*) totalcustomers,
	round(avg(score),0) avgscore
from customers
where country='USA';
END   $$
delimiter ;
call sp_country_avgscore;

-- PARAMETERS: Placeholders used to pass values as input from the user to the procedure ,
-- allowing dynamic data to be processed
-- For German cus find the total number of customers & the avg score
delimiter $$
create procedure sp_customer_summary_country(in sp_country varchar(50))
begin
select
	count(*) totalcustomers,
	round(avg(score),0) avgscore
from customers
where country=sp_country;
end $$
delimiter $$;

call sp_customer_summary_country('Germany');

-- MULTIPLE STATEMENTS
delimiter $$
create procedure sp_customer_summary_country(in sp_country varchar(50))
begin
select
	count(*) totalcustomers,
	round(avg(score),0) avgscore
from customers
where country=sp_country;
-- Find the total no. of orders and total sales
select
	count(*) totalcustomers,
	sum(sales) totalsales
from orders o
join customers c on o.customerid = c.customerid
where country=sp_country;
end $$
delimiter $$;
call sp_customer_summary_country('Germany');

-- VARIABLES: Placeholder used to store values to be used later in the procedure
-- Parameters pass values into a stored procedure or return values back to the caller
-- Variables temporarily store values and manipulate data during its EXEC
-- 3 steps: 1. Declare Variables 2. Assign values to the variables 3. UseVariables
delimiter $$
create procedure sp_customer_summary_country(in sp_country varchar(50))
begin
declare totalcustomers int;
declare avgscore float;
select
	count(*) totalcustomers,
	round(avg(score),0) avgscore
    into totalcustomers, avgscore
from customers
where country=sp_country;

-- Total customers from germany : 2
-- Avg score from germany: 425

SELECT CONCAT('Total customers from ', sp_country, ' : ', cast(totalcustomers as char)) as declare_var1;
SELECT CONCAT('Avg score from ', sp_country, ' : ', cast(avgscore as char)) as declare_var2;

-- Find the total no. of orders and total sales
select
	count(*) totalcustomers,
	sum(sales) totalsales
from orders o
join customers c on o.customerid = c.customerid
where country=sp_country;

end $$
delimiter $$;
call sp_customer_summary_country('Germany');

-- CONTROL FLOW: IF - ELSE

delimiter $$
create procedure sp_customer_summary_country(in sp_country varchar(50))
begin
declare totalcustomers int;
declare avgscore float;
-- Prepare & Cleaup data
if exists(select 1 from customers where score is null and country = sp_country ) then
	SELECT 'Updating NULL Score to 0' AS Message;
	update customers set score=0 where score is null and country=sp_country;
else
		SELECT 'No null scores found' AS Message;
end if;

-- Generating Reports
select
	count(*) totalcustomers,
	round(avg(score),0) avgscore
    into totalcustomers, avgscore
from customers
where country=sp_country;

-- Total customers from germany : 2
-- Avg score from germany: 425

SELECT CONCAT('Total customers from ', sp_country, ' : ', cast(totalcustomers as char)) as declare_var1;
SELECT CONCAT('Avg score from ', sp_country, ' : ', cast(avgscore as char)) as declare_var2;

-- Find the total no. of orders and total sales
select
	count(*) totalcustomers,
	sum(sales) totalsales
from orders o
join customers c on o.customerid = c.customerid
where country=sp_country;

end $$
delimiter $$;
call sp_customer_summary_country('USA');

-- ERROR HANDLING - TRY_CATCH
/*
BEGIN TRY
-- SQL statements
END TRY
BEGIN CATCH
-- SQL statements
END CATCH
*/
-- It does not support in MySQL but supports in SQL server
-- EXCEPTION HANDLER 
/*
DECLARE EXIT(CONTINUE) HANDLER FOR SQLEXCEPTION
BEGIN
	select 'Error' as message
END
*/

delimiter $$
create procedure sp_customer_summary_country(in sp_country varchar(50))
begin
	declare totalcustomers int;
	declare avgscore float;
    -- ===================================
	-- Step 1: Prepare & Cleaup data
    -- ===================================
	if exists(select 1 from customers where score is null and country = sp_country ) then
		SELECT 'Updating NULL Score to 0' AS Message;
		update customers set score=0 where score is null and country=sp_country;
	else
		SELECT 'No null scores found' AS Message;
	end if;
	-- ==============================
	-- Step 2:Generating Reports
    -- ==============================
	select
		count(*) totalcustomers,
		round(avg(score),0) avgscore
		into totalcustomers, avgscore
	from customers
	where country=sp_country;

	-- Total customers from germany : 2
	-- Avg score from germany: 425

	SELECT CONCAT('Total customers from ', sp_country, ' : ', cast(totalcustomers as char)) as declare_var1;
	SELECT CONCAT('Avg score from ', sp_country, ' : ', cast(avgscore as char)) as declare_var2;

	-- Find the total no. of orders and total sales
	select
		count(*) totalcustomers,
		sum(sales) totalsales,
		10/0
	from orders o
	join customers c on o.customerid = c.customerid
	where country=sp_country;
end $$
delimiter $$;
call sp_customer_summary_country('USA');




































