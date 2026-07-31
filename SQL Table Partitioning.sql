use salesdb;

-- SQL Partitioning: Divide big table into smaller partitions while still being treated as a single logical table
/*
1. Partition Functoin
4. partition scheme
2. File Groups
3. Data Files
*/

-- 1. Partition Function: Define the logic on how to provide your data into partitions
-- Based on partition key like (Column, Region, DATE)
-- BOUNDARIES: belong to left Partition
-- 2. File Groups: Logical Container of one or more data files to help organize partitions

/* in SQL SERVER
-- LOGICAL
create partition function partitionbyyear(date)
as range left for values ('2022-12-31', '2023-12-31', '2024-12-31');

sys.partition_schema(metadata_infromation_schema)

2. FILE GROUPS
alter database [database_name] add filegroup [file_name];
alter database [database_name] remove filegroup [file_name]; to update the mistakes

sys.filegroups

--PHYSICAL
3. DATA FILES
 alter database [database_name] add file
 (
 name= '[name]'
 filename = '[filepath]'
 ) to filegroup [filegroup_name]
 
 sys.filegroups join sys.masterfiles where mf.database_id=db_id('[database_name]')
 
 4. Partition scheme
 create partition scheme [partitionscheme_name]
 as partition [partitionfunction_name]
 to filegroup ([filegroup_nmae]);
 
 sys.partition_schemes
 
 5. Create the partitioned table
 CREATE TABLE ord (
    order_id INT,
    order_date DATE,
    customer_id INT
) on [partitionscheme_name(order_date)]

6. Insert data into the partition table
insert into [partitiontable_name] values();

sys.partitions
*/
CREATE TABLE ord (
    order_id INT,
    order_date DATE,
    customer_id INT
)
PARTITION BY RANGE (YEAR(order_date)) (
    PARTITION p2022 VALUES LESS THAN (2023), -- p2022 is filegroup, values less than is boundaries
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION pmax VALUES LESS THAN MAXVALUE
);

































