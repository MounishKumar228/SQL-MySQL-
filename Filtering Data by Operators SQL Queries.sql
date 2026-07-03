use mydatabase;
/* Filtering Data
Comparision Operators*/
/* = operator
Retrieve all customers from USA*/
select *
from cus
where countrys='USA';
-- REtrieve all customers who are not from germany
select *
from cus
where countrys!='USA';
-- REtrieve all customers with score greater than 500
select *
from cus
where countrys!='USA'
and scores>500;
-- REtrieve all customers with score greater than equal 500
select *
from cus
where countrys!='USA'
and scores>=500;
-- REtrieve all customers with score less than 500
select *
from cus
where countrys!='USA'
and scores<500;
-- REtrieve all customers with score less than equal 500
select *
from cus
where countrys!='USA'
and scores<=500;
-- Logical Operators - AND, OR, NOT
-- AND
select *
from cus
where countrys!='Germany'
and scores<=500;
-- OR
select *
from cus
where countrys!='USA'
or scores<=500;
-- Not
select *
from cus
where not scores < 500;

-- Range Operator - BETWEEN
select *
from cus
where scores between 100 and 500;

select *
from cus
where scores >=100 and scores<=500;

-- Retrieve countries with either from Germany or USA(IN, NOT IN)
select *
from cus
where countrys in('Germany','USA');

select *
from cus
where countrys not in('Germany','USA');

-- Find all customers names starts with m
select *
from cus
where first_names like 'M%';
-- r in the 3rd position
select *
from cus
where first_names like '__r%';