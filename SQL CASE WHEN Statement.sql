use salesdb;
/* CASE - WHEN - ELSE
use case - Filtering Data
Purpose - Data Transformation
derive new information 
create new columns based on existing data
*/
/*create report showing total sales for each of the categories
High - sales>50
Medium - 2-50
Low - <20
*/
select 
orderid,
sales,
case 
	when sales>50 then 'High'
    when sales>=20 and sales<=50 then 'Medium'
    else 'Low'
end as category_sales
from orders;
-- To group according to category_sales - aggregate data
-- Use Sub-Query
select
category_sales,
sum(sales) as total_sales
from(
select 
orderid,
sales,
case 
	when sales>50 then 'High'
    when sales>=20 and sales<=50 then 'Medium'
    else 'Low'
end as category_sales
from orders
)t
group by category_sales
order by total_sales desc;

-- Use case2: Mapping
-- transform value from form to another
-- Retrieve employee details with gender displayed as full text
select
gender_full_text,
count(gender) as total_employees_by_gender
from(
select
employeeid,
firstname,
lastname,
gender,
case 
	when gender='M' then 'Male'
    else 'Female'
end as gender_full_text
from employees
)t
group by gender_full_text;

select
case
	when gender='M' then 'Male'
    else 'Female'
end as gender,
count(*) as total_employees_by_gender
from employees
group by
case
	when gender='M' then 'Male'
    else 'Female'
end;

-- Usecase3 - Handling Nulls
/* Find the avg scores of  customers and treat nulls as 0
and provide additional details such customerid and lastname
*/
select
customerid,
lastname,
score,
case
	when score is null then 0
    else score
end as score_clean,
round(avg(score) over(), 0) as average,
round(avg(case
	when score is null then 0
    else score
end ) over(),0) avg_score_clean
from customers;

select
customerid,
lastname,
score,
round(avg(case
	when score is null then 0
    else score
end ) over(),0) avg_score_clean
from customers;

-- Use case4 - Conditional aggregation
-- count how many times each customer has made an order with sales greater than 30
select
customerid,
count(*)
from orders
where sales>30
group by customerid;

select
customerid,
sum(
	case
		when sales>30 then 1
        else 0
	end) as salesflag
from orders
group by customerid;







