use salesdb;
/*In aggregate calculations null is totally ignored
except when using count(*)*/
-- Handle NULL in DATA AGGREGATIONS
-- Find the avg scores of customers
select
customerid,
score,
coalesce(score, 0) as score2,
round(avg(score) over(), 0) as avg_of_scores,
round(avg(coalesce(score, 0)) over(), 0) as avg_scores2
from customers;

-- Handle NULLS in MATHEMATICAL OPERATIONS
/* Dispaly teh full name of customers in a single field
by merging their first and last names
and add 10 bonus points to each customer score*/
select
customerid,
firstname,
lastname,
concat(firstname,' ',coalesce(lastname, '')) as full_name,
score,
coalesce(score, 0) + 10 bonus_score
from customers;

-- Handling NULLS in JOINS
-- Handling NULLS in SORTING DATA
/* Sort the customers from lowest to to highest score,
with nulls apperaing last */
select
customerid,
score,
coalesce(score, 999999999) type1_static,
case when score is null then 1 else 0 end type2_FLAG
from customers
order by coalesce(score, 999999999);
-- After solving CASE it sorts the data with same FLAG
select
customerid,
score,
case when score is null then 1 else 0 end type2_FLAG
from customers
order by case when score is null then 1 else 0 end, score; 

-- NULL function NULLIF
-- Replaces a real value with a NULL
/* compares 2 expressions 
-gives NULL if they are equal
-First value if they are not equal
nullif(value1, value2) */
-- Use Case DIVISION by ZERO
-- preventing the error dividing by zero
-- Find the sales price for each order by dividibg sales by quantity
select
orderid,
sales,
quantity,
round(sales / nullif(quantity, 0), 0) as price
from orders;

-- IS NULL & IS NOT NULL
-- IS NULL USE CASE FILTERING DATA
-- Searching for missing information
-- identify the customers who has no score
select  
*
from customers
where score is null;
-- List all customers who have score
select
*
from customers
where score is not null;

-- USE CASE Anti-Joins
-- Find the unmatched rows between 2 tables
-- List all details of customers who have not placedany orders
select
	c.*
    from customers c 
    left join orders o 
    on c.customerid = o.customerid
    where o.customerid is null; -- Better to use keyword
    
    -- NULL, EMPTY STRING, BLANK SPACE
    with orders as(
    select 1 as id, 'A' as category union
    select 2, NULL union
    select 3, '' union
    select 4, ' '
    )
    select
    *,
    length(category) as categorylen
    from orders;
    
    -- HANDLING NULLS - DATA POLICIES
    /* 1. Only use NULLS and EMPTY string avoid blank spaces(use TRIM to remove blanks)
    2. only use NULLS avoid both EMPTY string and BLANK spaces (Use NULLIF to  rapalce
    EMPTY string and BLANK spaces to NULL)
    3.use default value 'UNKNOWN' and avoid using NULLS, EMPTY string, BLANK spaces
    */
	with orders as(
    select 1 as id, 'A' as category union
    select 2, NULL union
    select 3, '' union
    select 4, ' '
    )
select
*,
length(category) as categorylen,
trim(category) as policy1,
length(trim(category)) policy1_len,
nullif(trim(category), '') as policy2,
coalesce(nullif(trim(category), ''),'unknown') policy3,
length(coalesce(nullif(trim(category), ''),'unknown')) policy3_len
from orders;

/* USE CASES:
1. Data aggregations
2. Mathematical Operations
3. joining Tables
4. Sorting data
5. Finding  unmatched data - Left, right-anti join
6. Data policies 
*/



