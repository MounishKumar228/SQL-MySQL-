use mydatabase;
 -- Retrieve all data from customers and orders in two different results(No Join)
 select * from cus;
 
 select * from ord;
 
 /* Get all customers along with their orders
 but only for customers who have placed an order*/
 select *
 from cus
 inner join ord
 on cus.id = ord.customer_id;
 
select
	id,
    first_names,
    order_id,
    saless
from cus
inner join ord
on cus.id = ord.customer_id;

 /* Get all customers along with their orders
 including those without orders*/
 select
	id,
    first_names,
    order_id,
    saless
from cus
left join ord
on cus.id = ord.customer_id;

 /* Get all customers along with their orders
 including orders without matching customers*/
  select
	id,
    first_names,
    order_id,
    saless
from cus
right join ord
on cus.id = ord.customer_id;

 select
	id,
    first_names,
    order_id,
    saless
from ord
left join cus
on cus.id = ord.customer_id;

 select *
 from cus
 full join ord
 on id = customer_id;
 
 -- Get all customers who haven't placed an oreder
 
  select
	id,
    first_names,
    order_id,
    saless
from cus
left join ord
on cus.id = ord.customer_id
where ord.customer_id is null;

-- Get all orders without matching customers
 select *
 from cus
 full join ord
 on id = customer_id;
 
 -- Get all customers who haven't placed an oreder(Right-Anti Join)
  select
	id,
    first_names,
    order_id,
    saless
from ord
left join cus
on cus.id = ord.customer_id
where cus.id is null;

 select *
 from cus
 full join ord
 on id = customer_id;
 
 -- Get all customers who haven't placed an oreder
 
  select
	id,
    first_names,
    order_id,
    saless
from cus
full join ord
on id = customer_id
where id is null or customer_id is null; 

-- Get matching rows without using inner join
  select
	id,
    first_names,
    order_id,
    saless
from cus
left join ord
on cus.id = ord.customer_id
where ord.customer_id is not null;

-- Cross Join
select *
from cus
cross join ord;

use salesdb;

/* retrieve all orders along with the related customer, product, and employee details
for each order display:
orderid,customers name, product name, sales amount, Product price, Sales's persons names*/
select *
from customers;
select *
from employees;
select *
from orders;
select *
from orders_archive;
select *
from products;

select
	o.orderid, o.sales,
    c.firstname, c.lastname,
    p.product as productname, p.price,
    e.firstname as salespersonname
from orders as o
left join customers as c on o.customerid = c. customerid
left join products as p on o.productid = p.productid
left join employees as e on o.salespersonid = e.employeeid;
