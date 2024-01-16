/* `````````````````MUTATING TRIGGER```````````````````
 
 whenever we are doing dml operation and its the dml opr fire the trigger,
 and from within the body of trg if we are trying to read or write the same tble 
 then we will get mutating erroer
 
 
 the mut trg only occur in the row level trg
 it will not occur statement level trg...

*/



        

CREATE TABLE emp_tb1(empno NUMBER PRIMARY KEY,ename VARCHAR2(100),deptno NUMBER,job VARCHAR2(20),salary NUMBER);

CREATE TABLE emp_upd_log(empno NUMBER(10),upd_log VARCHAR2(100));

INSERT INTO emp_tb1 VALUES(1000,'king',10,'ceo',150000);
INSERT INTO emp_tb1 VALUES(1001,'ravi',10,'director',80000);
INSERT INTO emp_tb1 VALUES(1002,'surya',10,'sr manager',70000);
INSERT INTO emp_tb1 VALUES(1003,'raghu',10,'manager',60000);
INSERT INTO emp_tb1 VALUES(1004,'scott',10,'lead',50000);
INSERT INTO emp_tb1 VALUES(1005,'smith',10,'developer',40000);
INSERT INTO emp_tb1 VALUES(1006,'varun',10,'qa',40000);
commit;
DROP TABLE emp_upd_log;

DROP TABLE emp_upd_log;
SELECT * FROM emp_tb;
SELECT * FROM emp_upd_log;
--create trigger

CREATE OR REPLACE TRIGGER trg_validate
BEFORE UPDATE OF salary ON emp_tb1
FOR EACH ROW
DECLARE
 v_max_sal NUMBER:=100000;
-- v_max_sal NUMBER:=100000;

BEGIN
IF :new.salary < v_max_sal THEN
  INSERT INTO emp_upd_log VALUES(:new.empno,'salary update successfully ' || 
                                'old sal :'||:old.salary||',new salary  :'||:new.salary);
 
ELSE 
    :new.salary :=:old.salary;
    INSERT INTO emp_upd_log VALUES(:new.empno,'salary not updated.emp sal cannot exceed more than  '||v_max_sal);
END IF;
END;
/
--===================================================================================/


drop trigger trg_validate1;
--1st update
UPDATE emp_tb1 SET salary=65000
WHERE empno=1004;
--2nd update
 UPDATE emp_tb SET salary=88000
 WHERE empno=1001;

/
UPDATE emp_tb SET salary=30500
WHERE empno=1006;


UPDATE emp_tb1 SET salary=salary+15000
WHERE empno=1001;

SELECT * FROM emp_tb1;
SELECT * FROM emp_upd_log;
truncate table emp_upd_log;
--
select * from user_triggers
where table_name='EMP_TB1';

---------------------------------------------------------------------------------------------

--mutating error occur
--resolve the error







SELECT * FROM emp_tb1;
SELECT * FROM emp_upd_log;
TRUNCATE TABLE emp_upd_log;

drop trigger trg_validate;
CREATE OR REPLACE TRIGGER trg_validate
BEFORE UPDATE OF salary ON emp_tb1
FOR EACH ROW
DECLARE
 v_max_sal NUMBER;
-- v_max_sal NUMBER:=100000;

BEGIN

select salary into v_max_sal from emp_tb1
where job='ceo'
and deptno = :new.deptno;

IF (:new.salary < v_max_sal and :old.job <> 'CEO') or(:old.job ='CEO')THEN
  INSERT INTO emp_upd_log VALUES(:new.empno,'salary update successfully ' || 
                                'old sal :'||:old.salary||',new salary  :'||:new.salary);
 
ELSE 
    :new.salary :=:old.salary;
    INSERT INTO emp_upd_log VALUES(:new.empno,'salary not updated.emp sal cannot exceed more than  '||v_max_sal);
END IF;
END;
/

--error occur

--statement level trigger
drop trigger trg_ceo_sal;

CREATE OR REPLACE TRIGGER trg_ceo_sal
BEFORE UPDATE OF salary ON emp_tb1
BEGIN
SELECT salary INTO pkg1.v_max_sal FROM emp_tb1
WHERE job='ceo';
END;
/

drop package pkg1;

--pkg is used for globel variable
CREATE OR REPLACE PACKAGE pkg1
AS
v_max_sal NUMBER;
END;
/


drop trigger trg_validate_sal;

CREATE OR REPLACE TRIGGER trg_validate_sal
BEFORE UPDATE OF salary ON emp_tb1
FOR EACH ROW
DECLARE
 v_max_sal NUMBER;
BEGIN  

IF (:new.salary < pkg1.v_max_sal AND :new.job <> 'ceo') OR (:new.job='ceo')THEN
  INSERT INTO emp_upd_log VALUES(:new.empno,'salary update successfully' || 
                                'old sal :'||:old.salary||'new salary:'||:new.salary);
 
ELSE 
    :new.salary :=:old.salary;
    INSERT INTO emp_upd_log VALUES(:new.empno,'salary not updated.emp sal cannot exceed more than  '||pkg1.v_max_sal);
END IF;
END;
/



UPDATE emp_tb1 SET salary=11000
WHERE empno=1002;


UPDATE emp_tb1 SET salary=155000
WHERE empno=1001;

UPDATE emp_tb1 SET salary=155000
WHERE empno=1000;

UPDATE emp_tb1 SET salary=155000
WHERE empno=1001;

SELECT * FROM emp_tb1;
SELECT * FROM emp_upd_log;


------------------****************----------------------------




CREATE OR REPLACE TRIGGER trg_validate_cmnd
for UPDATE ON emp_tb1 COMPOUND TRIGGER
 v_max_sal NUMBER;
BEFORE STATEMENT IS
BEGIN
select salary into v_max_sal from emp_tb1
where job='ceo';
END BEFORE STATEMENT;

BEFORE EACH ROW IS
BEGIN

IF (:new.salary < v_max_sal and :old.job <> 'CEO') or(:old.job ='CEO')THEN
  INSERT INTO emp_upd_log VALUES(:new.empno,'salary update successfully ' || 
                                'old sal :'||:old.salary||',new salary  :'||:new.salary);
 
ELSE 
    :new.salary :=:old.salary;
    INSERT INTO emp_upd_log VALUES(:new.empno,'salary not updated.emp sal cannot exceed more than  '||v_max_sal);
END IF;
END BEFORE EACH ROW;
END;
/



UPDATE emp_tb1 SET salary=11000
WHERE empno=1002;


UPDATE emp_tb1 SET salary=85000
WHERE empno=1001;

UPDATE emp_tb1 SET salary=156000
WHERE empno=1000;

UPDATE emp_tb1 SET salary=45000
WHERE empno=1006;

SELECT * FROM emp_tb1;
SELECT * FROM emp_upd_log;

create or replace trigger trg_name
for update on emp_tbbefore compound trigger 
before statement is
begin
null;
end before statement ;
before each row is
null;
end before each row;
end ;
/


CREATE OR REPLACE TRIGGER trg_validate_cmnd
for UPDATE ON emp_tb1 COMPOUND TRIGGER

BEFORE STATEMENT IS
BEGIN
END BEFORE STATEMENT;

BEFORE EACH ROW IS
BEGIN
END BEFORE EACH ROW;

END;
/
