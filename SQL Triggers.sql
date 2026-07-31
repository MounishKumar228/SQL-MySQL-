-- TRIGGERS: Special STORED PROCEDURES(set ofstatements) that automatically runs in response to
-- a specific event on a table or view
/* Trigger Types
1. DDL Triggers: INSERT, UPDATE, DELETE - 2 types: AFTER, INSTEAD OF
2. DML TRIGGERS: CREATE, ALTER, DROP
3. LOGIN
*/
-- Trigger use case: LOGGING
/* (SQL SERVER)
Syntax
CREATE TRIGGER [trigger_nmae] on [table_name]
AFTER INSERT, UPDATE, DELETE (When) 
as
BEGIN
	SQL statements
END
*/

/* (MySQL)
Syntax
CREATE TRIGGER [trigger_nmae] on [table_name]
for each row
{BEFORE|AFTER} {INSERT|UPDATE|DELETE} (When)
BEGIN
	SQL statements
END

NEW & OLD special row references
NEW - INSERT & UPDATE
OLD - UPDATE & DELETE
*/
use salesdb;
create table employeelogs(
logid int auto_increment primary key, -- identity(1,1) starts with id=1 and increments by 1
employeeid int,
logmessage varchar(50),
logdate date
);
delimiter $$
create trigger trg_afterinsertemployee 
after insert
on employees for each row
begin
	insert into employeelogs(employeeid, logmessage, logdate)
    -- ========================================================
    /*select   (SQL server)
		employeeid,
        concat('New Employee Added = ', employeeid),
        now()
	from inserted
	*/
    -- =========================================================
    VALUES (
    NEW.employeeid,
    CONCAT('New Employee Added = ', NEW.employeeid),
    NOW()
);
end $$
delimiter ;
select  * from employeelogs;
insert into employees 
values
(6, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000, 3);



























