/* DATE-TIME FUNCTIONS
DAY, MONTH, YEAR, DATEPART, DATENAME, DATETRUNC, EOMONTH
FORMAT, CONVERT, CAST
DATEADD, DATEDIFF
ISDATE*/
use salesdb;
select
	orderid,
    orderdate,
    shipdate,
    creationtime,
	curdate() as today,
    now() as today_timestamp
from orders; 

select
creationtime,
-- datepart examples
day(creationtime) as date,
month(creationtime) as month,
year(creationtime) as year,
week(creationtime) as week,
quarter(creationtime) as quarter,
-- datename examples
monthname(creationtime) as month_name,
dayname(creationtime) as date_name,
date_format(creationtime, '%y-%m-%d %h:%i:%s') as trunc_datetime
from orders; 


-- Aggregations
select
date_format(creationtime, '%y') as trunc_datetime,
count(sales) as sales_count_per_year
from orders
group by date_format(creationtime, '%y');

-- how many orders were placed each month
select
monthname(orderdate),
count(*)
from orders 
group by monthname(orderdate);

-- ordersplaced during february
select 
monthname(orderdate),
count(*)
from orders
where month(orderdate)=2
group by monthname(orderdate);

select
orderdate,
date_format(orderdate,"%d-%m-%y")
from orders;

-- Formatting in desired order
select
	orderid,
	creationtime,
	concat(
    'Day ',
    date_format(creationtime, "%a %b")," ",
    'Q', quarter(creationtime)," ",
    date_format(creationtime, "%y %h:%y:%s")) as formatting
from orders;


select
date_format(orderdate,"%b %y"),
count(*)
from orders
group by date_format(orderdate,"%b %y");

-- Convert
select
creationtime,
convert(creationtime, date)
from orders;

-- Cast
select
creationtime,
cast(creationtime as date) as custom_cast
from orders;

-- DateADD(part, interval, value) in SQL server 
select
orderdate,
date_add(orderdate, interval 2 month) as month_add,
date_add(orderdate, interval -2 month) as month_add
from orders;

-- DateDIFF
select
	orderdate,
	shipdate,
	datediff(shipdate, orderdate) as datediff_in_days,
	timestampdiff(month, orderdate, shipdate)as datediff_in_months,
	timestampdiff(year, orderdate, shipdate) as datediff_in_year
from orders;

-- Find the avg shipping duration in days for each month
select
	monthname(orderdate),
	monthname(shipdate),
	round(avg(datediff(shipdate, orderdate)), 2) as avg_shipping_diff_in_days
from orders
group by monthname(orderdate), monthname(shipdate)
order by monthname(orderdate), monthname(shipdate);

-- TimeGap analysis
-- Find the number of  days between each order and previous order
select
	orderid,
	orderdate as current_orderdate,
	lag(orderdate) over (order by orderdate) as previous_orderdate,
	datediff(orderdate,
	lag(orderdate) over (order by orderdate)) as days_diff	
from orders;

-- isdate()
select
orderdate,
date(orderdate)
from orders;