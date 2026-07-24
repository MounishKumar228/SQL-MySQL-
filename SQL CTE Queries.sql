use salesdb;

-- COMMON TABLE EXPRESSION(CTE)
-- We cannot use orderby directly in the CTE
-- Adv: Readability, Modularity, Reusability
-- Types: None- Recursive CTE(Standalone & Nested CTE) & Recursive CTE
-- Non-recursive: is executed only once without any repetition
-- Standalone CTE: defined & used independently(doesn't rely on other CTE's or queries)
-- STANDALONE CTE
-- Step1: Find the total sales per customer
with CTE_total_sales as
(
select
customerid,
sum(sales) totalsales
from orders
group by customerid
)
-- Step2: Find the last orderdate per customer
, CTE_last_order as
(
select
customerid,
max(orderdate) lastorder
from orders o
group by customerid
)
-- Nested customer
-- Step3: Rank customers based on total sales per customer
, CTE_cus_rank as
(
select
customerid,
totalsales,
rank() over(order by totalsales desc) cusrank
from CTE_total_sales
)
-- Step4: Segment customers based on their total sales
, CTE_seg_cus as
(
select
customerid,
case when totalsales>100 then 'High'
	 when totalsales>80 then 'Medium'
     else 'low'
end as segments
from CTE_total_sales
)
-- Main Query
select
	c.customerid,
    c.firstname,
    c.lastname,
    cts.totalsales,
    clo.lastorder,
    ccr.cusrank,
    csc.segments
from customers c
left join CTE_total_sales as cts
on cts.customerid=c.customerid
left join CTE_last_order as clo
on clo.customerid = c.customerid
left join CTE_cus_rank as ccr
on ccr.customerid=c.customerid
left join CTE_seg_cus as csc
on csc.customerid=c.customerid;

-- RECURSIVE CTE: Self-referencing query that repetedly processes data until a specific condition is met
-- Generate a sequence of numbers from 1 to 20
with series as
(
-- Anchor Query
select
1 as mynumber
union all
-- Recursive Query
select
mynumber+1
from series
where mynumber<20
)
-- Main Query
select
*
from series;





















