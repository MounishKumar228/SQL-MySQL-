use salesdb;
/* Window Functions
1. Aggregate Functions - SUM, AVG, MIN, MAX, COUNT
2. Rank Functions - rank(), dense_rank, percentage_rank, nteil()
3. Value(analyticfunctions) - lag, lead, first_value, last_value
*/
/* avg(sales) over( partition by category order by orderdate
ROWS BETWEEN CURRENT ROW AND UNBOUNDED PRECEDING*/
select
orderid,
orderdate,
productid,
orderstatus,
sales,
sum(sales) over() totalsales,
sum(sales) over(partition by productid) salesbyproduct,
sum(sales) over(partition by productid, orderstatus) salesbyproductandstatus
from orders;

select
orderid,
orderdate,
sales,
rank() over(order by sales desc) salesrank
from orders;

/* Window Frame - defines a subset of rows within each window thatis relevant for the calculation
Frame types - ROWS and RANGE
Range: Frame Boundary(Lower value) - CURRENT ROW, N PRECEDING, UNBOUNDED PRECEDING
Frame Boundary(Higher value) - CURRENT ROW, N FOLLOWING, UNBOUNDED FOLLOWING
Cannot use FRAME clause without ORDER BY
LOWER value must come before HIGHER VALUE
Compact Frame - For only preceding the current row can be skipped
Short form - ROWS 2 preceding
Default FRAME - ROWS between unbounded preceding and current row
*/
/* Window functions rules:
1. can be used only in SELECT and ORDER BY CLAUSES(can't be used to filter data)
2. Nesing window functions is not allowed
3. SQL execute window functions after WHERE clause
4. Windows function can be used together with GROUP BY in the same query
only if the SAME COLUMNS are used
*/
select
orderid,
orderdate,
orderstatus,
sales,
sum(sales) over(partition by orderstatus order by orderdate
rows between current row and 2  following) totalsales
from orders;
-- Find the total sales for each orderstatus
-- only for 2 products 101 and 102
select
orderid,
productid,
orderstatus,
sum(sales) over(partition by orderstatus) totalsales
from orders
where productid in (101, 102);

-- Rank customers based on their total sales
select
customerid,
sum(sales) totalsales,
rank() over(order by sum(sales) desc) customerrankbysales
from orders
group by customerid;

-- AGGREGATE FUNCTIONS
-- COUNT
-- COUNT(*) - counts all rows regardless of whether any value is NULL
-- So use SALES instead of *
-- It allows all data types
-- Find the total number of orders
-- Find the total number of orders for each customer
-- Additionally provide details such as orderid, orderdate
select
customerid,
orderid,
orderdate,
count(*) over() totalorders,
count(orderid) over(partition by  customerid) totalorders
from orders;

-- Find the total number of customers
-- Find the total number of scores for customers
-- Additionally provide all the details
select
*,
count(*) over() totalcustomers,
count(score) over() totalscores
from customers;
/* Data Quality issues
Duplicates leads to inaccuracies in analysis
COUNT() can be used to identify duplicates and NULLS
*/
-- Check whetherthe table orders contains any duplicate rows
select
orderid,
count(*) over(partition by orderid) checkPK
from orders_archive;

select
*
from(
select
orderid,
count(*) over(partition by orderid) checkPK
from orders_archive)t where checkPK>1;

-- SUM
-- Use case: Part-to-whole - Shows the contribution of each data point to the overall dataset
-- Find the total sales across all orders
-- and the total sales for each product
-- additionally provide details such as orderid, orderdate
select
orderid,
orderdate,
productid,
sum(sales) over() totalsales,
sum(sales) over(partition by productid) salesbyproduct
from orders;
-- Find the Percentage contribution of each product's sales to the total sales
select
orderid,
productid,
sales,
sum(sales) over() totalsales,
round(cast(sales as float) / sum(sales) over() * 100,2) Percontribution
from orders;

-- AVERAGE(avg)
-- Convert NULLS to '0' value using COALESCE before using AVG
-- Find the avg sales across all orders
-- and find the avg sales for each product
-- Additionally provide details such as orderid, orderdate
select
orderid,
orderdate,
productid,
round(avg(coalesce(sales, 0)) over(), 1) avgsales,
round(avg(coalesce(sales, 0)) over(partition by productid), 1) avgsalesbyproduct
from orders;

select
customerid,
lastname,
score,
coalesce(score, 0) clearingnulls,
round(avg(score) over(),0) avgscore,
round(avg(coalesce(score, 0)) over(),0) avgafternonulls
from customers;
-- Find all orders where sales are higher than avg sales across all orders
select
*
from(
select
orderid,
sales,
round(avg(sales) over(),0) avgsales
from orders)t where sales > avgsales;

-- MIN & MAX
-- Find the highest & lowest sales across all orders
-- the highest & lowest sales for each product
-- Additionally provide details such as orderid, orderdate
select
orderid,
orderdate,
productid,
sales,
min(sales) over() minsales,
max(sales) over() maxsales,
min(sales) over(partition by productid) minsalesbyproduct,
max(sales) over(partition by productid) maxsalesbyproduct
from orders;
-- show the employees who have the highest salaries
select
*
from(
select
employeeid,
firstname,
lastname,
department,
salary,
max(salary) over(partition by department) maxsalarybydept
from employees)t where salary = maxsalarybydept;
select
distinct department
from employees;
select
*
from(
select
employeeid,
firstname,
lastname,
department,
salary,
max(salary) over() maxsalary
from employees)t where salary = maxsalary;
-- Calculate the deviation of each sale from both the minimum and maximun sales amounts

-- Analytical use cases of RUNNING TOTAL & ROLLING TOTAL
-- Tracking : Tracking  current  sales with target sales
-- Trend analysis : Providing insights into historical patterns
-- They aggregate sequence of numbers and the aggregation is updated each time a new member is added
-- Analysis over time
-- Running total : Aggregate values from the beginning upto the current point without dropping offolderdata
-- Rolling total: Aggragates all values within a fixed time window (e.g., 30 days)
-- As new data is added , the oldest data point will be dropped
-- Running total: sum(sales) over(order by month)
-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW(default)
-- Rolling total: sum(sales) over(order by month
-- ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) 
-- Calculate Moving avg of sales for each product over time
select
orderid,
orderdate,
productid,
sales,
round(avg(coalesce(sales, 0)) over(partition by productid order by month(orderdate)
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),0) movingavg
from orders;
-- including only the next order
select
orderid,
orderdate,
productid,
sales,
round(avg(coalesce(sales, 0)) over(partition by productid order by orderdate
ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING),0) rollingavg
from orders;


-- Ranking Functions(Row_number, cume_dist, rank, dense_rank, percent_rank, ntile)
-- Used to sort the data
-- top/bottom n analysis, Distribution analysis(percent_rank, cume_dist)
-- partition by(optional), order by(required), frame(not allowed)

-- ROW_NUMBER
-- rank the orders based on their sales from highest to lowest
select
orderid,
sales,
row_number() over(order by sales desc) salesrank_row,
rank() over(order by sales desc) salesrank_rank,
dense_rank() over(order by sales desc) salesrank_denserank
from orders;
-- Find the top highest sales for each product
select
*
from(
select
orderid,
productid,
sales,
row_number() over(partition by productid order by sales desc) salesrank
from orders)t where salesrank=1;
select
distinct productid
from orders;
-- Find the lowest 2 customers basedon their total sales
select
*
from(
select
customerid,
sum(sales) totalsales,
row_number() over(order by sum(sales)) salesrank
from orders
group by customerid)t where salesrank in (1, 2);
-- Assign unique ids to the rows of the 'orders_archive' table
select
row_number() over(order by orderid) uniqueid,
orderid,
sales
from orders_archive;
-- identify the duplicate rows in the table orders_archive
-- and return a clean result without any duplicates
select
*
from(
select
row_number() over(partition by orderid order by creationtime desc) rn,
oa.*
from orders_archive as oa)t where rn =1;
-- NTILE(N)
select
orderid,
sales,
ntile(1) over(order by sales desc) 1tile,
ntile(2) over(order by sales desc) 2tile
from orders;
-- Use case: Data segmentation
-- egment all orders into 3 categories: High, medium, low
select
*,
case
	when bucket= 1 then 'High'
	when bucket= 2 then 'Medium'
	else 'low'
end Salessegmentation
from(
select
orderid,
sales,
ntile(3) over(order by sales desc) bucket
from orders)t ;

-- in order to export the data, divide the orders into 2 tables
-- cume_dist: position nr / no. of of rows
-- percent_rank: position nr-1 / no. of rows-1
-- percent_rank: calculate the relative position of  each row
-- Findthe products that fall within the highest 40% of prices
select
*,
concat(distribution*100, '%') distperrank
from(
select
product,
price,
cume_dist() over(order by price desc) distribution
from products)t where distribution<=0.4;

select
*,
concat(distribution*100, '%') distperrank
from(
select
product,
price,
percent_rank() over(order by price desc) distribution
from products)t where distribution<=0.4;

-- VALUE WINDOW FUNCTIONS
-- Time series analysis: the processof analyzing the data to understand the trends, patterns and behaviour over time
-- YoY & MoM
/*Analyze the MoM performance by finding the %change
in sales between the current and previous months*/
-- first collect the data
select
orderid,
orderdate,
sales
from orders;
-- Find the totalsales per months
select
month(orderdate),
sum(sales)
from orders
group by month(orderdate);
-- Find the previous months sales by using lag window function
select
month(orderdate) ordermonth,
sum(sales) currentmonthsales,
lag(sum(sales)) over(order by month(orderdate)) previousmonthsales
from orders
group by month(orderdate);
-- Calculate the %change
select
*,
cms-pms as mom_change,
round((cms-pms) / pms *100, 1) as perchange
from(
select
month(orderdate) ordermonth,
sum(sales) cms,
lag(sum(sales)) over(order by month(orderdate)) pms
from orders
group by month(orderdate))t;
-- Customer retention analysis: measure customers behaviour
-- and loyalty to help business build strong relationships with customers

-- in order to analyze customer loyalty ,
-- rank customersbased on the avg days between their days
select
customerid,
round(avg(daysuntilnextorder), 0) avgdays,
rank() over(order by round(coalesce(avg(daysuntilnextorder), 999999), 0)) cusrank
from(
select
orderid,
customerid,
orderdate corder,
lead(orderdate) over(partition by customerid order by orderdate) norder,
datediff(lead(orderdate) over(partition by customerid order by orderdate), orderdate) daysuntilnextorder
from orders)t
group by customerid;
-- Find the lowes and highest sales for each product
select
orderid,
productid,
sales,
first_value(sales) over(partition by productid order by sales) lowvalue,
last_value(sales) over(partition by productid order by sales 
rows between current row and unbounded following) highvalue,
first_value(sales) over(partition by productid order by sales desc) highvalue2,
min(sales) over(partition by productid) lowsales2,
max(sales) over(partition by productid) highsales3
from orders;




















