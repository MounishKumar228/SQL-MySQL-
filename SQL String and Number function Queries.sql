use salesdb;
-- Concatenate first name and contry into one column
select
firstname, country,
concat(firstname, ' ' ,country) as name_country
from customers;

-- Convert the firstname to lower case
select
firstname, country,
concat(firstname, ' ' ,country) as name_country,
lower(firstname)
from customers;

-- Find customers whose first name has leading or trailing spaces
select
firstname
from customers
where firstname != trim(firstname);

-- Remove dashes from number
select
'123-456-7890',
replace('123-456-7890','-','/');

-- length of first_names
select
firstname,
length(firstname) as len_name
from customers;

-- Extract characters of first_names
select
firstname,
left(firstname, 3) as left_extract_name,
right(firstname, 4) as right_extract_name,
substring(firstname, 2, 4) as substring_extract_name
from customers;

-- Number functions
-- ROUND, ABS
 select
 3.19274,
 -19,
 round(3.19274, 2) as round_2,
 round(3.19274, 0) as round_0,
 abs(-19) as abs;


