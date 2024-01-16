
/*
  > pl/sql is a procedural language adv of sql  
    with the design features of programming language
  >you can include  sql and plsql sttmn in a single unit
   of code and sent it to server for execution in asingle go
  
-- Anonymous Block
   * variable declaration
   * condition and looping
   * cursor
   * Exception
--stored procedure
--stored function
--stored package
--Trigger

-- Structure




BEGIN
dbms_output.put_line('welcome to plsql topic');
END;
/
SET SERVEROUTPUT ON;
 

DECLARE
v_a NUMBER := 20000000;
v_b NUMBER := 30000000;
v_c NUMBER ;
BEGIN
v_c := v_a + v_b;
dbms_output.put_line(v_a||'+'||v_b||'='||v_c);
END;
/



DECLARE
emp1_id NUMBER := 2001;
emp2_id NUMBER :=20005;
emp NUMBER ;
BEGIN
emp := emp1_id + emp2_id;
dbms_output.put_line(emp1_id||'+'||emp2_id||'='||emp);
END;
/

DECLARE
em_id       NUMBER := 101;
dept_id     NUMBER :=10;
em_name     VARCHAR2(30) :='gowri';
salary      NUMBER := 25000;
dob         DATE := TO_DATE('25-07-1989');
join_dt     DATE := TO_DATE('20-03-2020','dd-mm-yyyy');
BEGIN
dbms_output.put_line('emp id:       '|| em_id);
dbms_output.put_line('dept id:      '||dept_id);
dbms_output.put_line('emp name:     '||em_name);
dbms_output.put_line('emp salary:   '||' ' ||salary);
dbms_output.put_line('date of birth:'||' '|| dob);
dbms_output.put_line('join date:    '|| TO_CHAR(join_dt,'dd month,year' ));
END;
/


--nodata variable assighn but value no mention
-- space variable assin value is assigned by space

DECLARE
em_id       NUMBER := 101;
dept_id     NUMBER :=10;
em_name     VARCHAR2(30) :='gowri';
salary      NUMBER := 25000;
dob         DATE := TO_DATE('25-07-1989');
join_dt     DATE := TO_DATE('20-03-2020','dd-mm-yyyy');
no_data     VARCHAR2(20);
space       VARCHAR2(10):= ' ';
BEGIN
dept_id :=20;
dbms_output.put_line('emp id:       '|| em_id);
dbms_output.put_line('dept id:      '||dept_id);
dbms_output.put_line('emp name:     '||em_name);
dbms_output.put_line('emp salary:   '||' ' ||salary);
dbms_output.put_line('date of birth:'||' '|| dob);
dbms_output.put_line('join date:    '|| TO_CHAR(join_dt,'dd month,year' ));
dbms_output.put_line('no data:      '||' '|| NVL(no_data,10));  --nvl: is null print 10 
dbms_output.put_line('space:        '||' '|| NVL(space,20));
END;
/


-- CONSTANT || DEFAULT || NOT NULL


cnstnt_v      CONSTANT NUMBER:= 21.34;
deptv_default NUMBER DEFAULT:= 100;
emp_id       NUMBER(10) NOT  NULL := 50;

DECLARE
cnstnt_v      CONSTANT NUMBER:= 21.34; 
deptv_default NUMBER DEFAULT 100;     --this syntax for default
emp_id       NUMBER(10) NOT  NULL := 50;
-- emp_id       NUMBER(10) NOT  NULL ; not null variable must have value
BEGIN
--cnstnt_v:=20;   we cant use like this tis s constant 
dbms_output.put_line('deptv_default:   '|| deptv_default);
dbms_output.put_line('emp_id        '||emp_id);
dbms_output.put_line('constant val        '||cnstnt_v);
END;
/


--SCOPE OF THE VARIABLE



<<ob>>
DECLARE                           --1b
v_a NUMBER :=1000;
v_c NUMBER:=2500;
BEGIN
DECLARE                           --2b
v_a NUMBER :=1500;
v_b NUMBER :=2000;
BEGIN
dbms_output.put_line(ob.v_a);    --1500
dbms_output.put_line(v_c);    --2500
dbms_output.put_line(v_b);
END;                              --2b
dbms_output.put_line(v_a);
--dbms_output.put_line(v_b); no scope for inner stmnt
END; 
--1b
/

--non plsql variable

VARIABLE a NUMBER;

DECLARE
v_a NUMBER :=10;
BEGIN
:a := v_a; 
END;
/
SELECT :a FROM dual;
PRINT :a; 
--write the query in plsql

SET SERVEROUTPUT ON;


DECLARE
v_max_sal NUMBER;
BEGIN
select MAX(salary) INTO v_max_sal 
FROM employees;
dbms_output.put_line('maximum salary      :' || v_max_sal);
END;
/

-- only one row return

DECLARE
v_department_id NUMBER;
v_first_name VARCHAR2(20);
v_salary NUMBER;
BEGIN
select department_id,first_name,salary
into v_department_id,v_first_name,v_salary 
FROM employees
WHERE employee_id = 160;
dbms_output.put_line('department_id      :' || v_department_id);
dbms_output.put_line('first_name         :' || v_first_name);
dbms_output.put_line('salary             :' || v_salary);

END;
/
select * FROM employees;

--more than row not return
DECLARE
v_department_id NUMBER;
v_first_name VARCHAR2(20);
v_salary NUMBER;
BEGIN
select department_id,first_name,salary
into v_department_id,v_first_name,v_salary 
FROM employees
WHERE department_id = 90;
dbms_output.put_line('department_id      :' || v_department_id);
dbms_output.put_line('first_name         :' || v_first_name);
dbms_output.put_line('salary             :' || v_salary);
END;
/
-- fetch the data type from table 
DECLARE
v_department_name departments.department_name%TYPE;
BEGIN
select department_name
into v_department_name 
FROM departments
WHERE department_id = 120;
dbms_output.put_line('department_name      :' || v_department_name);
END;
/

--fetch all column 

DECLARE
v_all_data departments%ROWTYPE;
BEGIN
select *
into v_all_data  
FROM departments
WHERE department_id = 90;
dbms_output.put_line('department_id      :' || v_all_data.department_id);
dbms_output.put_line('department_name    :' || v_all_data.department_name);
dbms_output.put_line('manager_id         :' || v_all_data.manager_id);
dbms_output.put_line('location_id        :' || v_all_data.location_id);
END;
/

select * from departments;

--create table 

CREATE TABLE test_plsql(id_num  NUMBER PRIMARY KEY);
 

BEGIN 
insert into test_plsql values(20);
insert into test_plsql values(30);
insert into test_plsql values(40);
insert into test_plsql values(50);
insert into test_plsql values(60);
insert into test_plsql values(70);

commit;
END;
/
SELECT * FROM test_plsql; 



BEGIN 
insert into test_plsql values(40);
END;
/

SET SERVEROUTPUT ON;





















    


















