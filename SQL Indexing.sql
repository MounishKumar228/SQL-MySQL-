use salesdb;
-- Index: Data structure provides quick access to data, optimizing the speed of queries
-- Category & Types: 3 Categories
-- Structure: Clustered & Non-Clustered
-- Storage: Row-store & column-store
-- Functions: Unique & Filtered

-- Structure: Clustered Index & Non-Clustered Index
-- HEAP STRUCTURE-Table  without clustered index(Rows are stored randomly without any particular order)
-- Fast WRITE & slow READ
/* Storing: Storage file -> Page(The smallest unit of data storage in database)
Types: Data Page(Metadata) & Index Page
Structure of  data page: Header-> Rows-> ...->offset array
*/
-- CLUSTERED INDEX
-- B - TREE: Leaf node- Data Pages
-- Intermediate nodes: IndexPages - Itstores the Keyvalues(pointers) to another page. It doesnt store the actual rows
-- NON - CLUSTEREDINDEX: It wont reorganize the data physical files, directly builds the the B-Tree
-- 1 (cusID) ->1(fileID):102(Page number):96(pafeoffset) ->  (ROW IDENTIFIER) -> INDEX PAGE -> Leaf Nodes
-- Syntax: CREATE [CLUSTEREED|NONCLUSTERED] INDEX index_name ON table_name (col1, col2,...)
-- default: NONCLUSTERED (optional section in syntax), Multiple Columns - COMPOSITE INDEX
-- EX: create index IX_cus_name on customers (lastname desc, firstname asc)
-- PRIMARY KEY creates a CLUSTERED INDEX by default
create table custable as(
select
*
from customers);
alter table custable add primary key(customerid);
create index idx_custable_cusid on custable (customerid);
drop index idx_custable_cusid on custable;
-- In MySQL if a column is PRIMARY KEY by default it is CLUSTEREDINDEX
-- We can only create a single CLUSTEREDINDEX
create index idx_custable_lastname on custable (lastname);
-- COMPOSITE INDEX
create index idx_custable_countryscore on custable (country, score);
/* A, B, C, D
-- IDEX will be used
A
A, B
A, B, C
-- INDEX will not be used
B
A, C
A, B, D
*/
-- STORAGE CATEGORY
-- ROWSTORE INDEX & COLUMNSTORE INDEX
/* CLUSTERED COLUMN STORE PROCESS
1. ROW GROUP(ex: divide 2M rows into two 1M rows) (helps improves performance by executing simultanously)
2. COLUMN SEGMENT
3. DATA COMPRESSION(techniques: DICT ex: active-1, inactive-2)
4. STORE in DATA PAGE(LOB-Large OBject Page)
*/
-- COLUMN STORE INDEX IS FASTER THAN ROWSTORE INDEX
-- Syntax: CREATE [CLUSTEREED|NONCLUSTERED] [COLUMNSTORE] INDEX index_name ON table_name (col1, col2,...)
-- MySQL does not support COLUMNSTORE INDEX
-- Any columns should not be mentioned in CLUSTERED COLUMNSTORE INDEX Becauseit clusters all columns in the table
-- Only one columnstore index is allowed in a table & multiple rowstore indexes is allowed

-- UNIQUE INDEX - ensuresthere are no duplicates in the column
-- Syntax: CREATE [UNIQUE] [CLUSTEREED|NONCLUSTERED] [COLUMNSTORE] INDEX index_name ON table_name (col1, col2,...)
create unique index idx_custable_cusid on custable (customerid);

-- FILTERED INDEX: includes rows with a specified condition
/*-- Syntax: CREATE [UNIQUE] [CLUSTEREED|NONCLUSTERED] [COLUMNSTORE] 
INDEX index_name ON table_name (col1, col2,...)
where [condition]*/
-- Cannot create a FILTERED INDEX on CLUSTERED & COLUMNSTORE INDEX

-- WHEN TO USE
/* HEAP: For inserinting(Write)
CLUSTEREDINDEX(ROWSTORE) COLUMNS: For PRIMARY KEYS or DATE COLUMNS (OLTP)
COLUMNSTORE INDEX: for analytical queries reducing sizeof  large table(OLAP)
NON-CLUSTERED INDEX: for NON_PK (foreign keys, joins, and Filters)
FILTERED INDEX: Target subset of data reduce size of index
UNIQUE INDEX: Enforces uniqueness improves query speed
*/
/* INDEX MANAGEMENT
1. MONITOR INDEX USAGE
2. Monitoring Missing Indexes
3. Monitor Duplicate Indexes
4. Update Statistics
5. Monitor  Fragmentation
*/
-- sys.indexes
-- sys.tables
-- sys.indexes_columns
-- sys.columns
-- sys.stats
-- List all indxes in specific table
show index from custable;
-- Monitoring Index Usage
-- Dynamic Management View(Provides real time insights into database performance and system health) is used
-- Syntax: sys.dm.db.index_usage_details
-- Monitoring Missing Indexes
/*
Syntax: sys.dm.db.missing_index_details (SQL Server)
gives suggestions for the query where possible indexes can be created on the table
*/
-- 3. Monitor Duplicate Indexes
-- Table -> Columnname -> Indexname -> Indextype
-- Syntax: Using COUNT & ORDERBY

-- 4. Update Statistics
-- Syntax: UPDATE STATISTICS table_name
-- exec sp_updatestats

-- 5. Monitor  Fragmentation(Unused spaces in data pages, data pages are out of order)
/*
2 Methods: REORGANIZE- Defragments leaf nodes to keep them sorted, Light Operation
REBUILD: Recreates indxes from scratch, Heavy Operation
Syntax: ALTER INDEX index_name ON table_name REORGANIZE (AVG_FRAGMEN_PER: 10 - 30%)
>30% REBUILD    SyntaX: ALTER INDEX index_name ON table_name REBUILD
<10 NO ACTION NEEDED
*/ 


-- EXECUTION PLAN: Tells why our QUERIES are SLOW
-- Roadmap generated ny a database on how it will execute your query step by step
/*1. Display Estimated Execution Plan(CTRL+L)(Predicts the exec plan without actually running the query)
2. Include Actual Execution Plan(CTRL+M) (Shows the exec plan as it occuredafter runninh the query)
3. INCLUDE LIVE QUERY STATISTICS (while running the query) (shows the real-time exec flow as the query runs)
*/
/* To read the data inside the table 3 types scans:
1. Table Scan: Reads the entire table page by page row by row
2. IndexScan: Scans all data in an index  to findthe matching rows
3. INDEX SEEK: A targetedsearch within an index retrieving only specific rows
*/
/*
-- INDEX SEEK only bring the give column in the created index
-- and KEY LOOKUP bring the rest of the columns matching the column of index seek column
-- atlast we need to join(combine) them 
-- 3 TYPES of JOIN ALGORITHMS:
1. NESTED LOOP: Compares tables row by row; best for small tables
2.HASH MATCH: Matches rows using the hash table; best for large tables
3.MERGE JOIN: Merge two sorted tables; efficient when both are sorted
*/
-- EXEC PLAN: ROWSTORE vs COLUMNSTORE
-- SQL HINTS:Commands you to add a query to force the database to run it ina specific way for better performance
-- Syntax: OPTION() ex: option(HASH JOIN)
-- Near the table - WITH(FORCESEEK) -- INDEXSEEK

-- AVOID OVER INDEXING
-- SLOW PERFORMANCE: when we use CREATE, INSERT, UPDATE, DELETE... we also have to update indexes
-- CONFUSE EXECUTION PLAN
-- STRATEGY
-- 1. INITIAL STRATEGY: UNDERSTAND the the nature of PROJECT(READ/WRITRE)
/*
-- OLAP: Online Analytical Processing EX: DATAWAREHOUSE
-- MULTIPLE SORCES --(COMBINE ETL)> DATAWAREHOUSE -> REPORTS
-- Best to use COLUMNSTOTRE Index
*/
/*
-- OLTP: Online Transactional Processing EX: E-Commerce, Financial, Banking
-- DB <-- (READ/WRITE)> APP
-- Best to use CLUSTERED INDEX PK
*/
-- OPTIMIZE READ/WRITE performance

-- 2. USAGE PATTERNS INEXING
-- Identify frequently used TABLES & COLUMNS
-- Choose Right Index
-- Test Index

-- 3. Scenario Based Indexing
-- Identify  SLOW queries
-- Choose Execution Plan
-- Choose Right Index
-- (TEST) Compare EXEC Plan

-- 4. Monitoring & Maintenance
--  MONITOR INDEX USAGE
--  Monitoring Missing Indexes
--  Monitor Duplicate Indexes
--  Update Statistics
--  Monitor  Fragmentation




































