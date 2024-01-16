create or replace procedure increase_salaries
    (v_salary_increase in out number, v_department_id pls_integer, v_affected_employee_count out number) as
    cursor c_emps is select * from employees_copy where department_id = v_department_id for update;
    v_old_salary number;
    v_sal_inc number := 0;
begin
    v_affected_employee_count := 0;
    for r_emp in c_emps loop
      v_old_salary := r_emp.salary;
      r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
      update employees_copy set row = r_emp where current of c_emps;
      dbms_output.put_line('The salary of : '|| r_emp.employee_id
                            || ' is increased from '||v_old_salary||' to '||r_emp.salary);
      v_affected_employee_count := v_affected_employee_count + 1;
      v_sal_inc := v_sal_inc + v_salary_increase + nvl(r_emp.commission_pct,0);
    end loop;
    v_salary_increase := v_sal_inc / v_affected_employee_count;
    dbms_output.put_line('Procedure finished executing!');
end;
/



--package

drop table emp;
create table emp
as select * from employees where department_id in (10,20,30,40);
select * from emp;

CREATE OR REPLACE PACKAGE emp_det
AS
PROCEDURE hire(e IN NUMBER,n1 IN VARCHAR2,n2 IN VARCHAR2,email IN VARCHAR2,hire IN DATE,j IN VARCHAR2,s IN NUMBER ,d IN NUMBER);
PROCEDURE fire(e IN NUMBER);
END;
/




 


CREATE OR REPLACE PACKAGE BODY emp_det
AS
PROCEDURE hire(e IN NUMBER,n1 IN VARCHAR2,n2 IN VARCHAR2,email IN VARCHAR2,hire IN DATE,j IN VARCHAR2,s IN NUMBER ,d IN NUMBER)
IS
  BEGIN                                                                    --210,'Gowri','Manager',50000,120
    INSERT INTO emp(employee_id,first_name,last_name,email,hire_date,job_id,salary,department_id)
            VALUES(e,n1,n2,email,hire,j,s,d);
    COMMIT;
  END hire;
PROCEDURE fire(e IN NUMBER)
IS
BEGIN
   DELETE emp WHERE employee_id=e;
END fire;
END emp_det;
/

set serveroutput on;
EXECUTE emp_det.hire(210,'Gowri','pathi','gowripa21','21-09-1998','Manager',50000,120);
EXECUTE emp_det.fire(210);


SELECT * FROM emp ORDER BY employee_id;
DESC emp;


CREATE OR REPLACE PROCEDURE add_sum(a IN NUMBER,b IN NUMBER)
AS
v_c  NUMBER;
BEGIN
v_c:=a+b;
dbms_output.put_line(v_c);
END add_sum;
/


CREATE OR REPLACE PROCEDURE sub_sum(a IN NUMBER,b IN NUMBER)
AS
v_c  NUMBER;
BEGIN
v_c:=a-b;
dbms_output.put_line(v_c);
END sub_sum;
/


CREATE OR REPLACE PROCEDURE mul_sum(a IN NUMBER,b IN NUMBER)
AS
v_c  NUMBER;
BEGIN
v_c:=a*b;
dbms_output.put_line(v_c);
END mul_sum;
/

CREATE OR REPLACE FUNCTION div_sum(a IN NUMBER,b IN NUMBER)
RETURN NUMBER
AS
v_c  NUMBER;
BEGIN
v_c:=a/b;
RETURN v_c;
END div_sum;
/


CREATE OR REPLACE PACKAGE sums_det
AS
PROCEDURE add_sum(a IN NUMBER,b IN NUMBER);
PROCEDURE sub_sum(a IN NUMBER,b IN NUMBER);
PROCEDURE mul_sum(a IN NUMBER,b IN NUMBER);
FUNCTION  div_sum(a IN NUMBER,b IN NUMBER)
RETURN NUMBER;
END sums_det;
/

CREATE OR REPLACE PACKAGE BODY sums_det
AS
/*PROCEDURE add_sum(a IN NUMBER,b IN NUMBER)
AS
v_c  NUMBER;
BEGIN
v_c:=a+b;
dbms_output.put_line(v_c);
END add_sum;
*/
PROCEDURE sub_sum(a IN NUMBER,b IN NUMBER)
AS
v_c  NUMBER;
BEGIN
v_c:=a-b;
dbms_output.put_line(v_c);
END sub_sum;

PROCEDURE mul_sum(a IN NUMBER,b IN NUMBER)
AS
v_c  NUMBER;
BEGIN
v_c:=a*b;
dbms_output.put_line(v_c);
END mul_sum;

FUNCTION div_sum(a IN NUMBER,b IN NUMBER)
RETURN NUMBER
AS
  v_c  NUMBER;
BEGIN
    v_c := a / b;
     RETURN v_c;
END div_sum;

END sums_det;
/

EXECUTE sums_det.add_sum(100,200);
/

DECLARE
v_div NUMBER;
BEGIN
dbms_output.put_line('Addition');
sums_det.sub_sum(300,200);
dbms_output.put_line('subtraction');
sums_det.add_sum(100,200);
dbms_output.put_line('multiplication');
sums_det.mul_sum(100,200);
dbms_output.put_line('divition');
SELECT sums_det.div_sum(1000,10)INTO v_div FROM dual;            
dbms_output.put_line(v_div);
END;
/


DECLARE
v_div NUMBER;
BEGIN 
SELECT sums_det.div_sum(100,10) INTO v_div FROM DUAL;
END; 
/

select * FROM user_source;
where name='EMPLOYEES';

 mile_2_kilo CONSTANT NUMBER :=0.3445;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  000000
 

    
DROP PROCEDURE PROC_name
DROP FUNCTION FUNC_name
DROP PACKAGE PACK_name
DROP PACKAGE BODY PACK_name
/
``````````````````````````````````````````````````````````````````````````````````````````````````````
CREATE OR REPLACE PACKAGE emp_pkg
AS
PROCEDURE emp_prsn_det(v_id employees.employee_id%TYPE);
PROCEDURE emp_emplmn_det(v_id employees.employee_id%TYPE);
PROCEDURE emp_bonus(v_id employees.department_id%TYPE);
END;
/
```````````
CREATE OR REPLACE PACKAGE BODY emp_pkg
AS
PROCEDURE emp_prsn_det(v_id employees.employee_id%TYPE)
AS
v_empid employees.employee_id%TYPE;
v_fname employees.first_name%TYPE;
v_lname employees.last_name%TYPE;
v_email employees.email%TYPE;
v_phnum employees.phone_number%TYPE;
 BEGIN 
SELECT employee_id,first_name,last_name,email,phone_number INTO v_empid,v_fname,v_lname,v_email,v_phnum 
FROM employees
WHERE employee_id=v_id;
   dbms_output.put_line(v_empid);
   dbms_output.put_line(v_fname||v_lname);
   dbms_output.put_line(v_email);
   dbms_output.put_line(v_phnum);
END emp_prsn_det;

PROCEDURE emp_emplmn_det(v_id employees.employee_id%TYPE)
AS
v_empid employees.employee_id%TYPE;
v_fname employees.first_name%TYPE;
v_dpit employees.department_id%TYPE;
v_salary employees.salary%TYPE;
v_hire_date employees.hire_date%TYPE;
v_jobid employees.job_id%TYPE;

 BEGIN 
SELECT employee_id,first_name,department_id,salary,hire_date,job_id INTO v_empid,v_fname, v_dpit,v_salary,v_hire_date,v_jobid
FROM employees
WHERE employee_id=v_id;
   dbms_output.put_line(v_empid);
   dbms_output.put_line(v_fname);
   dbms_output.put_line(v_dpit);
   dbms_output.put_line(v_salary);
   dbms_output.put_line(v_hire_date);
   dbms_output.put_line(v_jobid);

END emp_emplmn_det;
PROCEDURE emp_bonus(v_id employees.department_id%TYPE)
AS
CURSOR bonus_det
IS
SELECT employee_id,first_name,department_id,salary  FROM employees WHERE department_id=v_id;

 BEGIN 
UPDATE employees 
SET salary =salary-1500
WHERE department_id=v_id;

  FOR I IN bonus_det
   LOOP  
   dbms_output.put_line('employee_id    :'||i.employee_id);
   dbms_output.put_line('first_name     :'||i.first_name);
   dbms_output.put_line('department_id  :'||i.department_id);
   dbms_output.put_line('salary         :'||i.salary);
  END LOOP;

END emp_bonus;
END emp_pkg;
/
EXEC emp_pkg.emp_bonus(113);
```````````````
EXEC emp_pkg.emp_emplmn_det(113);

``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````

SELECT salary FROM employees WHERE departm

set serveroutput on;



--============---UDAMY-------------------

CREATE OR REPLACE PACKAGE emp_pkg AS 
  TYPE emp_table_type IS TABLE OF employees%rowtype INDEX BY PLS_INTEGER;
  v_salary_increase_rate NUMBER := 1000; 
  v_min_employee_salary  NUMBER := 5000;
  CURSOR cur_emps IS 
   SELECT * FROM employees;
  
  PROCEDURE increase_salaries;
  FUNCTION  get_avg_sal(p_dept_id int) RETURN NUMBER;
  v_test    INT := 4;
  FUNCTION  get_employees RETURN emp_table_type;
  FUNCTION  get_employees_tobe_incremented RETURN emp_table_type;
  PROCEDURE increase_low_salaries;
  FUNCTION  arrange_for_min_salary(v_emp employees%rowtype) RETURN employees%rowtype;
END EMP_PKG;
/

/************************** Package Body ***************************/
CREATE OR REPLACE PACKAGE BODY emp_pkg AS
  
  v_sal_inc INT  := 500;
  v_sal_inc2 INT := 500;
  FUNCTION get_sal(e_id employees.employee_id%TYPE) RETURN NUMBER;
  PROCEDURE print_test IS 
  BEGIN
    dbms_output.put_line('Test : '|| v_sal_inc);
    dbms_output.put_line('Tests salary :'|| get_sal(102));
  END;
  
  PROCEDURE increase_salaries AS
  BEGIN
    FOR r1 IN cur_emps LOOP
      UPDATE employees_copy 
      SET    salary = salary + salary * v_salary_increase_rate
      WHERE employee_id = r1.employee_id;
    END LOOP;
  END increase_salaries;
  
  FUNCTION get_avg_sal(p_dept_id int) RETURN NUMBER AS
    v_avg_sal number := 0;
  BEGIN
  print_test;
    SELECT avg(salary) 
    INTO   v_avg_sal 
    FROM   employees_copy 
    WHERE  department_id = p_dept_id;
    RETURN v_avg_sal;
  END get_avg_sal;
  
  FUNCTION get_sal(e_id employees.employee_id%TYPE) RETURN NUMBER IS 
    v_sal number := 0;
  BEGIN
    SELECT salary 
    INTO   v_sal 
    FROM   employees 
    WHERE  employee_id = e_id;
    RETURN v_sal;
  END;
  
  /* This function returns all the employees in employees table */
  FUNCTION get_employees RETURN emp_table_type IS 
    v_emps emp_table_type;
  BEGIN
    FOR cur_emps IN (SELECT * FROM employees_copy) LOOP
      v_emps(cur_emps.employee_id) := cur_emps;
    END LOOP;
    RETURN v_emps;
  end;
  
  /*
    This function returns the employees which are under the minimum salary
    of the company standards and to be incremented by the new minimum salary
  */
  FUNCTION get_employees_tobe_incremented RETURN emp_table_type IS
    v_emps emp_table_type;
    i employees.employee_id%TYPE;
  BEGIN
    v_emps := get_employees;
    i := v_emps.first;
      WHILE i IS NOT NULL LOOP
        IF v_emps(i).salary > v_min_employee_salary THEN
          v_emps.delete(i);
        END IF;
        i := v_emps.next(i);
      END LOOP;
    RETURN v_emps;
  END;
  
  /*
    This procedure increases the salary of the employees 
    who has a less salary then the company standard.
  */
  PROCEDURE increase_low_salaries AS 
    v_emps emp_table_type;
    v_emp employees%rowtype;
    i employees.employee_id%type;
  BEGIN
    v_emps := get_employees_tobe_incremented;
    i := v_emps.first;
    WHILE i is not null loop
      v_emp := arrange_for_min_salary(v_emps(i));
      UPDATE employees_copy 
      SET    row = v_emp    
      WHERE  employee_id = i;
      i := v_emps.next(i);
    END LOOP;
  END increase_low_salaries;
 
  /*
    This function returns the employee by arranging the salary based on the 
    company standard.
  */
  FUNCTION arrange_for_min_salary(v_emp in out employees%rowtype) RETURN employees%rowtype IS 
  BEGIN
    v_emp.salary := v_emp.salary + v_salary_increase_rate;
    IF v_emp.salary < v_min_employee_salary THEN
      v_emp.salary := v_min_employee_salary;
    END IF;
    RETURN v_emp;
  END;
  /
  /***************************************************************/
BEGIN
  v_salary_increase_rate := 500;
  INSERT INTO logs VALUES('EMP_PKG','Package initialized!',sysdate);
END emp_pkg;


