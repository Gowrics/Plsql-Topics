explain plan for select * from departments;
explain plan for select * from departments where department_id=10;

select * from table(dbms_xplan.display());

--nested loop join  emp high -- dept low -->unique index

explain plan for 
select e.first_name,e.department_id,e.salary,d.department_name 
FROM employees e,departments d
where e.department_id=d.department_id
and e.employee_id=100;

select * from table(dbms_xplan.display());


--hash join   dept high --loct high --> no index

create table dept_as
as select * from departments;


create table emp_as
as select * from employees;


create table loct_as
as select * from locations;

select * from dept_as;
select * from loct_as;
explain plan for
select d.department_id,d.location_id,l.street_address from dept_as d,loct_as l
where d.location_id=l.location_id;

select * from table(dbms_xplan.display());


--sort join   dept high --loct high --> non unoque and order by 
create index empind on emp_as(employee_id);


select * from user_indexes where table_name='EMP_AS';

explain plan for
select d.department_id,d.location_id,l.street_address from dept_as d,loct_as l
where d.location_id=l.location_id
and d.department_id<=50
order by d.department_name ;
 
select * from table(dbms_xplan.display());

explain plan for 
select * from emp_as
where employee_id =100;

select * from table(dbms_xplan.display());  --cost is 2 

-- index invalid

ALTER INDEX empind  UNUSABLE;

select * from table(dbms_xplan.display());  --cost is 3 


select * FROM user_ind_columns
where table_name ='EMPLOYEES';

--status valid
select * FROM user_indexes
where table_name ='EMP_AS';

--make invalid
ALTER INDEX DEPIND  UNUSABLE;
ALTER INDEX DEPIND  REBUILD;
ALTER INDEX DEPIND  REBUILD ONLINE;



create index empind on emp_as(employee_id);
 
 
 select table_name,last_analyzed from user_tables;
 /
 begin
 dbms_stats.gather_table_stats('HR','locations');
 end;
 /
 
 
 
 select * from user_indexes where table_name='DEPARTMENTS';

DESC user_indexes;

DESC user_ind_columns;


select * from user_tab_partitions;
