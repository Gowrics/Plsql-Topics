-- curser 
--its private working area its hold query resuld and execute one by one

--imp cursor ->if th qur return single row op  (sql%rowcount)
--exp cursor -> if our qur return more than one row. we need to declare it (explicit_cursor_name%rowcount)

-- ERROR MSG exact fetch returns more than requested number of rows
feature
notfound 


found 
is open
rowcount

%type
%rowtype
loop
cursor for loop
parameterised cursor
for update of
where current of
nowait
--ex:1 using not found
DECLARE
v_first_name VARCHAR2(20);
v_employee_id NUMBER;
v_salary NUMBER;
v_hire_date DATE; 
v_department_id NUMBER;
cursor emp_c
is
select first_name,employee_id,salary,hire_date,department_id -- declare the cursor
from employees 
where department_id=80;
BEGIN
open emp_c; --open the cursor memory
LOOP
fetch emp_c 
into v_first_name,v_employee_id,v_salary,v_hire_date,v_department_id;
EXIT WHEN emp_c%NOTFOUND;
dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('department_id      :' || v_department_id);
dbms_output.put_line('first_name         :' || v_first_name);
dbms_output.put_line('employee_id        :' || v_employee_id);
dbms_output.put_line('salary             :' || v_salary);
dbms_output.put_line('hire_date          :' || v_hire_date);
END LOOP;
close emp_c;
dbms_output.put_line('--------------------------------------------');
END;
/ 
--ex

DECLARE 
  v_department_id employees.department_id%TYPE;
 CURSOR dep_tb
 IS
 SELECT DISTINCT(department_id) FROM employees
 WHERE salary < 10000;
BEGIN
 OPEN dep_tb;
  LOOP  
   EXIT WHEN dep_tb%NOTFOUND;
   FETCH dep_tb INTO v_department_id ;
   dbms_output.put_line('departments   :'||v_department_id);
  END LOOP;
 CLOSE dep_tb;
END;
/
 
set serveroutput on;



--ex2: using found


DECLARE
v_first_name VARCHAR2(20);
v_employee_id NUMBER;
v_salary NUMBER;
v_hire_date DATE; 
v_department_id NUMBER;
cursor emp_c
is
select first_name,employee_id,salary,hire_date,department_id -- declare the cursor
from employees 
where department_id=90;
BEGIN
open emp_c; --open the cursor memory
LOOP
fetch emp_c 
into v_first_name,v_employee_id,v_salary,v_hire_date,v_department_id;
dbms_output.put_line('--------------------yess------------------------');
EXIT WHEN emp_c%FOUND;

dbms_output.put_line('--------------------------------------------');
dbms_output.put_line('department_id      :' || v_department_id);
dbms_output.put_line('first_name         :' || v_first_name);
dbms_output.put_line('employee_id        :' || v_employee_id);
dbms_output.put_line('salary             :' || v_salary);
dbms_output.put_line('hire_date          :' || v_hire_date);
--EXIT WHEN emp_c%FOUND;
END LOOP;
close emp_c;
dbms_output.put_line('--------------------------------------------');
END;
/ 
cl scr;


select e.employee_id,e.department_id,d.department_name  from employees e,departments d
where d.department_id(+)=e.department_id(+);




-- check the cursor close or not

DECLARE
v_first_name      employees.first_name%type;
v_employee_id     employees.employee_id%type;
v_salary          employees.salary%type;
v_hire_date       employees.hire_date%type; 
v_department_id   employees.department_id%type;
v_count NUMBER:= 0;   
   cursor emp_c
   is
   select first_name,employee_id,salary,hire_date,department_id -- declare the cursor
   from employees 
   where department_id=50; --change the dept_id
BEGIN
    open emp_c; --open the cursor memory
    LOOP
    fetch emp_c 
    into v_first_name,v_employee_id,v_salary,v_hire_date,v_department_id;
    EXIT WHEN emp_c%NOTFOUND;
       dbms_output.put_line('--------------------------------------------');
       dbms_output.put_line('(' || emp_c%ROWCOUNT ||')');
       dbms_output.put_line('department_id      :' || v_department_id);
       dbms_output.put_line('first_name         :' || v_first_name);
       dbms_output.put_line('employee_id        :' || v_employee_id);
       dbms_output.put_line('hire_date          :' || v_hire_date);
    v_count :=v_count+1;
    END LOOP;
--    close emp_c;
   dbms_output.put_line('--------------------------------------------');
   --dbms_output.put_line('No Of Rows' || emp_c%ROWCOUNT); -- suppose we close emp c before its not wrk///.  
   dbms_output.put_line('No Of Rows                :'||v_count); -- suppose we close emp c we use this method.  

      if emp_c%isopen then
      close emp_c;
      dbms_output.put_line('cursor closed');
      ELSE
      dbms_output.put_line('cursor already closed');
      end if;
END;
/ 
cl scr;




--(DECLARE
v_first_name      employees.first_name%type;
v_employee_id     employees.employee_id%type;
v_salary          employees.salary%type;
v_hire_date       employees.hire_date%type; 
v_department_id   employees.department_id%type;
v_count NUMBER:= 0;   
--)   
-- using cursor with for loop
DECLARE    
   cursor emp_c
   is
   select first_name,employee_id,salary,hire_date,department_id -- declare the cursor
   from employees 
   where department_id=50; --change the dept_id
BEGIN
    FOR i IN emp_c
      LOOP
        dbms_output.put_line('*****************************************');
        dbms_output.put_line('Row Count          :' || emp_c%ROWCOUNT);
        dbms_output.put_line('department_id      :' || i.department_id);
        dbms_output.put_line('first_name         :' || i.first_name);
        dbms_output.put_line('employee_id        :' || i.employee_id);
        dbms_output.put_line('hire_date          :' || i.hire_date);
--EXIT WHEN emp_c%ROWCOUNT= 40;
    END LOOP;
   dbms_output.put_line('*******************************************');
 END;
/ 

-- using cursor with sub query

DECLARE
v_count NUMBER:=0;
BEGIN
   FOR i IN (select * FROM departments)
   LOOP
     dbms_output.put_line('****************');
     dbms_output.put_line('dpt_id      :' || i.department_id);
     dbms_output.put_line('dpt_name    :' || i.department_name);
     dbms_output.put_line('manager_id  :' || i.manager_id);
     dbms_output.put_line('location_id :' || i.location_id);
     dbms_output.put_line('v_count     :' || v_count);
     v_count :=v_count + 1;
END LOOP;
END;
/
 cl scr;   
-- PARAMETERIZED CURSOR
  par cr pass the paramenter into the cursor and use that in query
  par cr define only dattype no need to mention length
  we can set the default value to the paramenter..
 --scope of the parameter is locally






DECLARE 
   cursor emp_c(p_department_id NUMBER)
   --cursor emp_c(p_department_id NUMBER DEFAULT 90)
   IS
   SELECT employee_id,first_name,hire_date,salary,department_id
   FROM employees
   WHERE department_id = p_department_id;
  -- i employees%ROWTYPE;  --its optional
BEGIN
  
   FOR i IN emp_c(90)
   LOOP
   
       dbms_output.put_line('--------------------------------------------');
       dbms_output.put_line('department_id      :' || i.department_id);
       dbms_output.put_line('first_name         :' || i.first_name);
       dbms_output.put_line('employee_id        :' || i.employee_id);
       dbms_output.put_line('hire_date          :' || i.hire_date);
   END LOOP;
       dbms_output.put_line('--------------------------------------------');
  FOR i IN emp_c(60)
   LOOP
  dbms_output.put_line('--------------------------------------------');
       dbms_output.put_line('department_id      :' || i.department_id);
       dbms_output.put_line('first_name         :' || i.first_name);
       dbms_output.put_line('employee_id        :' || i.employee_id);
       dbms_output.put_line('hire_date          :' || i.hire_date);
      
    END LOOP;
END;
/
------------------------------------


declare
cursor  low_sal(p_sal number)
is
select employee_id,department_id,salary from employees
where salary <=p_sal;
begin
for i in low_sal(2500) 
loop
       dbms_output.put_line('emp_id           :  ' || i.employee_id);
       dbms_output.put_line('department_id    :  ' || i.department_id);
       dbms_output.put_line('salary_id    :  ' || i.salary);
       dbms_output.put_line('count    :  ' ||low_sal%rowcount);

end loop;
end;
/
------------------------------------------------------------------------


begin
for i in (select employee_id,department_id,salary from employees
where salary <=3500) 
loop
       dbms_output.put_line('emp_id           :  ' || i.employee_id);
       dbms_output.put_line('department_id    :  ' || i.department_id);
       dbms_output.put_line('salary_id    :  ' || i.salary);
       --dbms_output.put_line('count    :  ' ||i%rowcount);
end loop;
end;
/



-- FOR UPDATE OF
--WHERE CURRENT OF
-- nowait we dont wait to lock a row,when the row is already locked by someone
-- without nowait clause we will wait for locked row become unlocked
select * FROM emp1;
   
DECLARE
    CURSOR emp_c
    IS
    SELECT employee_id,first_name,TO_CHAR(hire_date,'yy') hire_date,salary,department_id
    FROM emp1 FOR UPDATE OF salary NOWAIT;
      
    BEGIN
      FOR i IN emp_c
      LOOP                                                                                                                                                                                                                                                                                                  r
         IF i.hire_date= 02 THEN
                  UPDATE emp1
                    SET salary = salary/4
                  WHERE CURRENT OF emp_c;
                END IF;
       dbms_output.put_line('department_id      :' || i.department_id);
       dbms_output.put_line('first_name         :' || i.first_name);
       dbms_output.put_line('employee_id        :' || i.employee_id);
       dbms_output.put_line('hire_date          :' || i.hire_date);
       dbms_output.put_line('salary             :' || i.salary);
      
            END LOOP;
            END;
            /


    SELECT employee_id,first_name,TO_CHAR(hire_date,'yy') hire_date,salary,salary/4 sals,department_id
    FROM emp1 ;
            
      rollback;      
select department_id,TO_CHAR(hire_date,'yyyy') FROM emp1
where  TO_CHAR(hire_date,'yyyy') =03;

SELECT * FROM employees
   WHERE hire_date= TO_DATE('17-06-2003','dd-mm-yyyy');
   
SELECT first_name , salary, hire_date, TO_CHAR(hire_date,'yyyy')FROM employees
     WHERE TO_CHAR(hire_date,'yyyy')= 2007 ;


select * from emp1;
/     
desc emp1;
---------------------not work---------------------------------------/
     
declare
cursor sal_upd
is
select * from emp1
where department_id=50
and nvl(commission_pct,0)=0
for update of commission_pct;
begin
for i in sal_upd
loop
update emp1
set commission_pct=10
where current of sal_upd;
end loop;
end;
/
-------------------------------
select * from emp1;


declare
cursor sal_upd
is
select * from emp1
where  commission_pct is null
for update of salary;
begin
for i in sal_upd
loop
update emp1
set salary=salary+10000
where current of sal_upd;
end loop;
end;
/

rollback;
--------------------------------------------


DECLARE
v_empid NUMBER:=&emp_id;
CURSOR upd_sal
IS
SELECT * FROM emp1
where employee_id =v_empid
FOR UPDATE OF salary NOWAIT;
BEGIN
FOR i IN upd_sal
LOOP
--     IF i.employee_id=v_empid THEN
       UPDATE emp1
       SET salary =salary-1000
       WHERE CURRENT OF upd_sal;
  --END IF ;
       dbms_output.put_line('employee_id        :' || i.employee_id);
       dbms_output.put_line('first_name         :' || i.first_name);
       dbms_output.put_line('salary             :' || i.salary);
END LOOP;
END;
/

----------------------------------------------------------------
select * FROM emp1 ;

--practice version

DECLARE 
v_department_name departments.department_name%TYPE;
--v_department_name VARCHAR2(50)
BEGIN
SELECT department_name INTO v_department_name FROM departments
WHERE department_id = 90;
dbms_output.put_line('department_name    ='||v_department_name);
 END;
/

--ex 2 explicit cursor

DECLARE
v_name      employees.first_name%type;
v_empid     employees.employee_id%type;
v_salary          employees.salary%type;
v_hire_date       employees.hire_date%type; 
v_deptid   employees.department_id%type;
v_count NUMBER :=0;
CURSOR emp1_c
IS 
 select first_name,employee_id,department_id,salary
 from employees
 where department_id=90;
BEGIN
OPEN emp1_c;
LOOP
v_count := v_count +1;
FETCH emp1_c INTO v_name,v_empid,v_deptid,v_salary;
EXIT  WHEN emp1_c%NOTFOUND;
dbms_output.put_line('     -----------------------------------');
dbms_output.put_line('NAME    ='||v_name);
dbms_output.put_line('emp id  ='||v_empid);
dbms_output.put_line('dept id ='||v_deptid);
dbms_output.put_line('salary    ='||v_salary);
--EXIT  WHEN emp1_c%NOTFOUND;
END LOOP;
CLOSE emp1_c;
dbms_output.put_line('*******END********');
IF emp1_c%ISOPEN THEN 
CLOSE emp1_c;
dbms_output.put_line('*******closed********');
 ELSE
 dbms_output.put_line('*******ALREADY CLOSED********');
END IF;
 END;
/

-- v_alldata
cl scr;

DECLARE
v_count NUMBER :=0;
CURSOR emp1_c
IS 
 select first_name,employee_id,department_id,salary
 from employees
 where department_id=90;
v_alldata emp1_c%ROWTYPE;

BEGIN
OPEN emp1_c;
LOOP
v_count := v_count +1;
FETCH emp1_c INTO v_alldata;
EXIT  WHEN emp1_c%NOTFOUND;
dbms_output.put_line('     -----------------------------------');
dbms_output.put_line('NAME    ='||v_alldata.first_name);
dbms_output.put_line('emp id  ='||v_alldata.employee_id);
dbms_output.put_line('dept id ='||v_alldata.department_id);
dbms_output.put_line('salary    ='||v_alldata.salary);
dbms_output.put_line('count    ='||v_count);

--EXIT  WHEN emp1_c%NOTFOUND;
END LOOP;
CLOSE emp1_c;
dbms_output.put_line('*******END********');
END;
/





cl scr;

-- using for loop

DECLARE
CURSOR emp1_c
IS 
 select first_name,employee_id,department_id,salary
 from employees
 where department_id=60;
BEGIN
FOR i IN emp1_c
LOOP
 dbms_output.put_line('NAME    ='||i.first_name);
 dbms_output.put_line('emp id  ='||i.employee_id);
 dbms_output.put_line('dept id ='||i.department_id);
 dbms_output.put_line('salary    ='||i.salary);
 dbms_output.put_line('--------------------------');
END LOOP;
END;
/

--parameterized cursor
DECLARE
CURSOR emp1_c(p_department_id NUMBER,p_first_name VARCHAR2)
IS 
 select first_name,employee_id,department_id,salary
 from employees
 where department_id = p_department_id
 AND first_name = p_first_name;

BEGIN
FOR i IN emp1_c(60,'Diana')
LOOP
 dbms_output.put_line('NAME    ='||i.first_name);
 dbms_output.put_line('emp id  ='||i.employee_id);
 dbms_output.put_line('dept id ='||i.department_id);
 dbms_output.put_line('salary    ='||i.salary);
 dbms_output.put_line('--------------------------');
END LOOP;

FOR i IN emp1_c(80,'Charles')
LOOP
 dbms_output.put_line('NAME    ='||i.first_name);
 dbms_output.put_line('emp id  ='||i.employee_id);
 dbms_output.put_line('dept id ='||i.department_id);
 dbms_output.put_line('salary    ='||i.salary);
 dbms_output.put_line('--------------------------');
END LOOP;
END;
/

 -- more simplify not need to cursor declare

DECLARE
v_count NUMBER := 0;
BEGIN
FOR i IN (select * from employees)
LOOP
v_count:= v_count+1;
 dbms_output.put_line('DEPT_ID    ='||i.department_id);
 dbms_output.put_line('NAME  ='||i.first_name);
 --dbms_output.put_line('dept id ='||i.);
 --dbms_output.put_line('salary    ='||i.salary);
 dbms_output.put_line('--------------------------');
-- dbms_output.put_line('count    :'||v_count);
END LOOP;
 dbms_output.put_line('count    :'||v_count);
END;
/


DECLARE
v_count NUMBER := 0;
BEGIN
FOR i IN (select * FROM departments)
LOOP
v_count:= v_count+1;
 dbms_output.put_line('NAME    ='||i.department_id);
 dbms_output.put_line('emp id  ='||i.department_name);
 --dbms_output.put_line('dept id ='||i.);
 --dbms_output.put_line('salary    ='||i.salary);
 dbms_output.put_line('--------------------------');
 dbms_output.put_line('count    :'||v_count);
END LOOP;
END;
/


  
  
 select * FROM departments; 
 
 DROP TABLE emp;
CREATE TABLE emp
AS 
SELECT * FROM employees;

 select * FROM emp
 WHERE department_id=80; 

-- for update of

DECLARE
CURSOR emp1_c
IS 
 select department_id,first_name,employee_id,salary
 from emp FOR UPDATE OF salary;
BEGIN
FOR i IN emp1_c
LOOP

     IF i.department_id =80 THEN
        UPDATE emp
         SET salary =salary +500
          WHERE CURRENT OF emp1_c;
        dbms_output.put_line('NAME    ='||i.first_name);
        dbms_output.put_line('emp id  ='||i.employee_id);
        dbms_output.put_line('dept id ='||i.department_id);
        dbms_output.put_line('salary    ='||i.salary);
        dbms_output.put_line('--------------------------');
     END IF;
 END LOOP;
END;
/

--more ex


 select *
-- first_name,salary,department_id 
FROM emp;
 WHERE department_id =40; 



DECLARE
CURSOR emp1_c
IS 
 select department_id,first_name,employee_id,salary
 from emp FOR UPDATE OF salary;
BEGIN
FOR i IN emp1_c
LOOP

     IF i.department_id =40 THEN
        UPDATE emp
         SET salary =4000;
         -- WHERE employee_id =i.employee_id;
        dbms_output.put_line('NAME    ='||i.first_name);
        dbms_output.put_line('emp id  ='||i.employee_id);
        dbms_output.put_line('dept id ='||i.department_id);
        dbms_output.put_line('salary    ='||i.salary);
        dbms_output.put_line('--------------------------');
     END IF;
     
 END LOOP;
END;
/



DECLARE
CURSOR emp1_c
IS 
 select department_id,first_name,employee_id,salary
 from emp FOR UPDATE OF salary;
BEGIN
FOR i IN emp1_c
LOOP
     IF i.department_id =60 THEN
        UPDATE emp
         SET salary =10000
          WHERE employee_id =i.employee_id;
        dbms_output.put_line('NAME    ='||i.first_name);
        dbms_output.put_line('emp id  ='||i.employee_id);
        dbms_output.put_line('dept id ='||i.department_id);
        dbms_output.put_line('salary    ='||i.salary);
        dbms_output.put_line(emp1_c%ROWCOUNT);
        dbms_output.put_line('--------------------------');

     END IF;
 END LOOP;
END;
/
ROLLBACK;
SELECT * FROM EMP;
SET SERVEROUTPUT ON;


SELECT * FROM emp;

BEGIN
DELETE EM=-werc,m   
WHERE DEPARTMENT_ID=60;
if SQL%notfound then
dbms_output.put_line(sql%rowcount||' rows are affected');
end if;
if SQL%found then
dbms_output.put_line(sql%rowcount||' rows are affected');
end if;


dbms_output.put_line(sql%rowcount);
END;
/

--ref cursor
--we can use single cursor to open completely different fetch of querys..

-- fer cursor is allow us to open different sets of query vs exp cursor does not allow to open

DECLARE 
CURSOR emp_dep_name IS 
SELECT e.first_name empname,d.department_name deptname
FROM employees e,departments d
WHERE e.department_id = d.department_id;
BEGIN   
     dbms_output.put_line('  empname          deptname ' );
     dbms_output.put_line('______________________________' );     
FOR i IN emp_dep_name
LOOP
     dbms_output.put_line(rpad(i.empname,15,' ')||i.deptname);
END LOOP;
END;
/


DECLARE
  TYPE emp_dep_ref IS REF CURSOR;
  edname emp_dep_ref;
  v_name VARCHAR2(30);
  v_id NUMBER(30);
BEGIN
OPEN edname FOR select first_name FROM emp1;
FOR i IN edname
LOOP
   dbms_output.put_line(i.edname);
END LOOP;
END;
/

declare
s sys_refcursor;
BEGIN
OPEN s for SELECT * FROM employees;
END;
/

exec s;