
--pragma autonomous transaction
CREATE TABLE tst_prag (id NUMBER NOT NULL);    ---table creatiom

BEGIN
INSERT INTO tst_prag VALUES(1);
INSERT INTO tst_prag VALUES(2);                 --insert and call procedure
INSERT INTO tst_prag VALUES(3);
call_insrt;
INSERT INTO tst_prag VALUES(7);
--INSERT INTO tst_prag VALUES(NULL);              --null not accept
commit;
END;
/
--create procedure
CREATE OR REPLACE PROCEDURE call_insrt
AS
BEGIN
INSERT INTO tst_prag VALUES(4);                --procedure creation
INSERT INTO tst_prag VALUES(5);
INSERT INTO tst_prag VALUES(6);
END;
/
SELECT * FROM tst_prag;      --after that execute no data found
DROP TABLE tst_prag;       

--pragma autonomous transaction
DROP TABLE tst_prag;       --1st drop the tab

CREATE TABLE tst_prag (id NUMBER NOT NULL);    ---table creatiom

BEGIN
INSERT INTO tst_prag VALUES(1);
INSERT INTO tst_prag VALUES(2);                 --insert and call procedure
INSERT INTO tst_prag VALUES(3);
call_insrt;
INSERT INTO tst_prag VALUES(6);
INSERT INTO tst_prag VALUES(NULL);              --null not accept
commit;
END;
/
--create procedure
CREATE OR REPLACE PROCEDURE call_insrt
AS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
INSERT INTO tst_prag VALUES(4);                --procedure creation
INSERT INTO tst_prag VALUES(5);
commit;
END;
/
SELECT * FROM tst_prag;      --after that execute no data found

--its ex not clear output 
 
 --another ex
 DROP TABLE tst_prag;       --1st drop the tab

CREATE TABLE tst_prag (id NUMBER);    ---table creatiom

BEGIN
INSERT INTO tst_prag VALUES(1);
INSERT INTO tst_prag VALUES(2);                 --insert and call procedure
INSERT INTO tst_prag VALUES(3);
call_insrt;
INSERT INTO tst_prag VALUES(6);
INSERT INTO tst_prag VALUES(7);              --null not accept
ROLLBACK;
END;
/
--create procedure
CREATE OR REPLACE PROCEDURE call_insrt
AS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
INSERT INTO tst_prag VALUES(10);                --procedure creation
INSERT INTO tst_prag VALUES(20);
INSERT INTO tst_prag VALUES(30);
INSERT INTO tst_prag VALUES(40);
commit;
ROLLBACK;
END;
/
select * from tst_prag;


--example 2
CREATE TABLE ts1(tb1_roll_no NUMBER);
CREATE TABLE ts2(tb2_roll_no NUMBER);
drop table ts2;
BEGIN
INSERT INTO ts1 VALUES(10);
INSERT INTO ts1 VALUES(20);                 --insert and call procedure
INSERT INTO ts1 VALUES(30);
insert_ts;
INSERT INTO ts1 VALUES(60);
INSERT INTO ts1 VALUES(70);              --null not accept
rollback;
END;
/
DROP TABLE ts1;

CREATE OR REPLACE PROCEDURE insert_ts
AS
BEGIN
INSERT INTO ts2 VALUES(100);
INSERT INTO ts2 VALUES(200);              
INSERT INTO ts2 VALUES(300);
INSERT INTO ts2 VALUES(400);              
commit;
rollback;
END;
/

select * FROM ts1;
select * FROM ts2;


--ex 3
sp2;
 rollback;
 start_track_sp --> start insert    pragma
 1000 -> delete
 --error
 1000-> insert
 end_track_sp   --> end  insert     pragma
commit;
end sp1;




create table tst1(id_num integer,emp_name varchar2(23));

insert into tst1 values(10,'ram');
insert into tst1 values(11,'saam');
insert into tst1 values(12,'nam');

select * from tst1;

-- in fun we use insert satmnt using pragma 

create or replace function cnt_fn return number
as
PRAGMA AUTONOMOUS_TRANSACTION;

cnts number;
begin
insert into tst1 values(13,'gaam');
commit;
select count(1) into cnts from tst1;
return cnts;
end;
/

seleqct cnt_fn from dual;


drop table emp purge ;

create table emp
as (select * from employees where department_id=50);

insert into emp (select * from employees where department_id=60);
rollback;
select * from emp;


create or replace function cnt_fn return varchar2
as
PRAGMA AUTONOMOUS_TRANSACTION;
cnts number;
cnts1 number;
avrg number;
avrg1 number;
p_avrg varchar2(100);
begin
select count(1) into cnts from emp;
select avg(salary) into avrg from emp;
p_avrg:='count :'||cnts||'avarage :' ||avrg;

insert into emp (select * from employees where department_id=60);
commit;
select count(1) into cnts1 from emp;
select avg(salary) into avrg1 from emp;

p_avrg:='count :'||cnts||'avarage :' ||round(avrg)||'new count :'||cnts1||'new avg'||round(avrg1);

return p_avrg;
end;
/


select cnt_fn from dual;



create table w1(ids number);
create table w2(ids number);
select  * from w1;
select  * from w2;

truncate table w1;

begin 
insert into w1 values(1);
insert into w1 values(2);
insert into w1 values(3);
ins_sp();
insert into w1 values(4);
insert into w1 values(5);
rollback;
end;

/


create or replace procedure ins_sp
as
PRAGMA AUTONOMOUS_TRANSACTION;
begin 
insert into w1 values(10);
insert into w1 values(20);
insert into w1 values(30);
insert into w1 values(40);
insert into w1 values(50);
commit;
end;
/





-----------------------------------------------------------

select * from emp;
DECLARE
   l_salary   NUMBER;
   PROCEDURE nested_block IS
   PRAGMA autonomous_transaction;
    BEGIN
     UPDATE emp
       SET salary = salary + 5000 --2200
       WHERE employee_id = 128;
   COMMIT;
   END;
BEGIN
   SELECT salary INTO l_salary FROM emp WHERE employee_id = 127; --2400
   dbms_output.put_line('Before Salary of 127 is'|| l_salary);
   SELECT salary INTO l_salary FROM emp WHERE employee_id = 128;
   dbms_output.put_line('Before Salary of 128 is'|| l_salary);    
   UPDATE emp 
   SET salary = salary + 5000 
   WHERE employee_id = 127;

nested_block;
ROLLBACK;

 SELECT salary INTO  l_salary FROM emp WHERE employee_id = 127;
 dbms_output.put_line('After Salary of 127 is'|| l_salary);
 SELECT salary INTO l_salary FROM emp WHERE employee_id = 128;
 dbms_output.put_line('After Salary of 128 is '|| l_salary);
end;

