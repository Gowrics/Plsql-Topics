---Performance Tuning
   
   Making optimal use of system using existing resources.
   It is used to improve the performance of the query.
   
 1. Explain PLAN
 
	  Command prompt:
	    SET AUTOT ON;
	
Execution Plan
----------------------------------------------------------
Plan hash value: 4167016233
--------------------------------------------------------------------------------
| Id  | Operation         | Name        | Rows  | Bytes | Cost (%CPU)| Time
--------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |             |    27 |   567 |     3   (0)| 00:00:01
|
|   1 |  TABLE ACCESS FULL| DEPARTMENTS |    27 |   567 |     3   (0)| 00:00:01
--------------------------------------------------------------------------------


SQL> SELECT * FROM TABLE(dbms_xplan.display());

2. Re Write the query.
   Prefer inbuilt operator for the query. (AND, IN, OR, NOT, EXISTS, ALL, ANY).
   
   Next preference JOIN (check the join condition , less records data contain left side). 
   IF Low volume of data prefer JOIN.
   
   SUBQUERY IF large volume of data prefer SUBQUERY.
   Try to avoid correlated subquery if its needed last preference.

3. INDEX
    
	The column most used in where clause.     
	   
    To check Index is available on the column. SELECT * FROM USER_IND_COLUMNS;
    We need to check the status valid / unusable in  SELECT * FROM USER_INDEXES;
	If it is unusable, we need to rebuild.  ALTER INDEX index_name REBUILD;
	Else need to create an index when the Volume of table is large (10L records) 
   
    After rebuild , again run the query, still performance is slow because 
	the volume of data lesss than 10% output.
	
	So we drop the index. DROP INDEX index_name;
	
	Frequently DML operations makes degrade the INDEX performance.
	
4.HINTS

    OPTIMIZER Hints can be used with SQL statements to alter execution plans.
	Hints provide a mechanism to instruct/direct 
	the optimizer to choose a certain query execution plan based on the specific criteria.

Types of Hints:

	Single TABLE - specified on one table or view (ex:Index)
	Multi TABLE  - specified on more tables or views (ex:leading)
	Query Block  - it has been operating on single query block. (star transformation)
	STATEMENT    - statement hints apply to the entire sql statements (all rows)

Hints for access paths:

	Index_ASC -> to retrive the old records
	
		SELECT /*+INDEX_ASC(employee_id) */ first_name, salary FROM employees
		order by employee_id;
	
	Index_DESC -> to retrive the latest records
	
		SELECT /*+INDEX_DESC(employee_id) */ first_name, salary FROM employees
		order by employee_id DESC;
		
	ALL_Rows -> The ALL_ROWS hint instructs the optimizer to optimize a statement block 
				with a goal of best throughput—that is, minimum total resource consumption. 
	
		SELECT /*+ ALL_ROWS */ employee_id, last_name, salary, job_id
		FROM employees 	WHERE employee_id = 102;
  
	
	First_Rows -> The FIRST_ROWS hint specified without an argument,
					which optimizes for the best plan to return the first single row, 
					is retained for backward compatibility and plan stability only.

		SELECT /*+ FIRST_ROWS(10) */ employee_id, last_name, salary, job_id
		FROM employees   WHERE department_id = 20;


	
	APPEND -> Bulk collect. data stored in block structre, new data occupy in empty.
	
	
    Data is appended to the end of the table, 
	rather than attempting to use existing free space within the table.
    Data is written directly to the data files, by-passing the buffer cache.
    Referential integrity constraints are not considered. *
    No trigger processing is performed. *
	
  SQL> CREATE TABLE t1 AS SELECT * FROM all_objects WHERE 1=2;

Table created.

SQL> SET AUTOTRACE ON STATISTICS
SQL> INSERT INTO t1 SELECT * FROM all_objects;

88773 rows created.


Statistics
----------------------------------------------------------
        613  recursive calls
      11792  db block gets
     116808  consistent gets
          2  physical reads
   10222352  redo size
        370  bytes sent via SQL*Net to client
        552  bytes received via SQL*Net from client
          3  SQL*Net roundtrips to/from client
       3142  sorts (memory)
          0  sorts (disk)
      88773  rows processed

SQL> TRUNCATE TABLE t1;

Table truncated.

SQL> INSERT /*+ APPEND */ INTO t1 SELECT * FROM all_objects;

88773 rows created.


Statistics
----------------------------------------------------------
        307  recursive calls
       1573  db block gets
     114486  consistent gets
          0  physical reads
   10222864  redo size
        366  bytes sent via SQL*Net to client
        566  bytes received via SQL*Net from client
          3  SQL*Net roundtrips to/from client
       3138  sorts (memory)
          0  sorts (disk)
      88773  rows processed

SQL> COMMIT;

Commit complete.
	
	
	No_Index ->
	
	        
	This can be used for query testing purpose without dropping the actual index. 
	In some cases queries will give better performance without indexes. 
	This difference can be tested using this hint.
	This hint applies to function_based, B-tree, bitmap, cluster indexes.
			 
	select /*+no_index*/ * from hint_test where object_type='FUNCTION';
	
	PARALLEL ->
	
	The target table or index must be doing a full-scan operation,
	A starting point for the parallel degree us cpu_count-1
	(the truly fastest degree is determined empirically via timing the query. ... 
	If the table is aliased, the parallel hint must also be aliased.
	
	select /*+PARALLEL(4)*/ e.department_id, d.department_name, MIN(salary), MAX(salary) 
	FROM employees e, departments d WHERE e.department_id=d.department_id 
	GROUP BY e.department_id, d.department_name

	
5. TABLE PARTITION 

	To handle the large volume of data. Thats why we suggest table partition to 
	improve the performance. To oraganizes the tables to be subdivided into
	 smaller pieces. Each piece of the database object is called a partition.
	 
	 1.Range 2. List 3. Hash 4. Composite
	 
	 
 1.Range	 
	 
CREATE TABLE sales_range 
(salesman_id  NUMBER(5), 
salesman_name VARCHAR2(30), 
sales_amount  NUMBER(10), 
sales_date    DATE)
PARTITION BY RANGE(sales_date) 
(
PARTITION sales_jan2000 VALUES LESS THAN(TO_DATE('01/02/2000','MM/DD/YYYY')),
PARTITION sales_feb2000 VALUES LESS THAN(TO_DATE('01/03/2000','MM/DD/YYYY')),
PARTITION sales_mar2000 VALUES LESS THAN(TO_DATE('01/04/2000','MM/DD/YYYY')),
PARTITION sales_apr2000 VALUES LESS THAN(TO_DATE('01/05/2000','MM/DD/YYYY'))
);


 2. List 
 
 CREATE TABLE sales_list
(salesman_id  NUMBER(5), 
salesman_name VARCHAR2(30),
sales_state   VARCHAR2(20),
sales_amount  NUMBER(10), 
sales_date    DATE)
PARTITION BY LIST(sales_state)
(
PARTITION sales_west VALUES('California', 'Hawaii'),
PARTITION sales_east VALUES ('New York', 'Virginia', 'Florida'),
PARTITION sales_central VALUES('Texas', 'Illinois'),
PARTITION sales_other VALUES(DEFAULT)
);



 3. Hash

Hash Partitioning Example

CREATE TABLE sales_hash
(salesman_id  NUMBER(5), 
salesman_name VARCHAR2(30), 
sales_amount  NUMBER(10), 
week_no       NUMBER(2)) 
PARTITION BY HASH(salesman_id) 
PARTITIONS 4 
STORE IN (ts1, ts2, ts3, ts4);

4. COMPOSITE

Composite Partitioning Range-Hash Example

CREATE TABLE sales_composite 
(salesman_id  NUMBER(5), 
 salesman_name VARCHAR2(30), 
 sales_amount  NUMBER(10), 
 sales_date    DATE)
PARTITION BY RANGE(sales_date) 
SUBPARTITION BY HASH(salesman_id)
SUBPARTITION TEMPLATE(
SUBPARTITION sp1 TABLESPACE ts1,
SUBPARTITION sp2 TABLESPACE ts2,
SUBPARTITION sp3 TABLESPACE ts3,
SUBPARTITION sp4 TABLESPACE ts4)
(PARTITION sales_jan2000 VALUES LESS THAN(TO_DATE('02/01/2000','MM/DD/YYYY'))
 PARTITION sales_feb2000 VALUES LESS THAN(TO_DATE('03/01/2000','MM/DD/YYYY'))
 PARTITION sales_mar2000 VALUES LESS THAN(TO_DATE('04/01/2000','MM/DD/YYYY'))
 PARTITION sales_apr2000 VALUES LESS THAN(TO_DATE('05/01/2000','MM/DD/YYYY'))
 PARTITION sales_may2000 VALUES LESS THAN(TO_DATE('06/01/2000','MM/DD/YYYY')));

 
 