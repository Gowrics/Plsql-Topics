

select name from v$database;


--TRIGGER
/*

--a trigger is plsql block structure which is automatically fire when the event
occur in the database
--the evant can be ddl,dml,or system event
-- a triger we cannot manually invoke like a procedure,package,fun we cnnt manually exucute the trg
the trg automatticcaly fire when ever event occur

types
--dml,ddl,system trg,instead of trg,compound trg

differnce

dml or ddl trg return on the top of table wherus
instead of trg return on the top of views

compound trg
compine the dml trg in single trg
..

```````````````````````````````````````````````````
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
``````````````````````````````````````````````````````

Event :insert , update,delete                N        GG
timing:before,after

      t1      t2
       1      1
       
       
       12     1
       13     1

purpose of trg

  autiting
  logging information
  security for transaction
  prevent invalid data or transaction
  ddl trg for autitng 
  system trgg
   




*/

 
 drop table bus_amnt;
 create table bus_amnt(s_no number(10),partner_nm varchar2(20),amount number(20));
insert into bus_amnt values(1,'raju',10000);
insert into bus_amnt values(2,'manokar',25000);
insert into bus_amnt values(3,'ramani',19000);
insert into bus_amnt values(4,'karan',40000);
insert into bus_amnt values(5,'manju',31000);
insert into bus_amnt values(6,'mathalai',15000);
select * from bus_amnt;
 

 delete  bus_amnt  where rownum >=8;

 
 set serveroutput on;
 create or replace trigger sec_busn
 before insert on bus_amnt
declare
tbcnt number(10);
 begin
 RAISE_APPLICATION_ERROR(-20004,'transaction not possible');
 select count(*) into tbcnt from bus_amnt;
 dbms_output.put_line('please not insert any information'||user);
 dbms_output.put_line('counts of tb '|| tbcnt);

 delete  bus_amnt  where s_no >=6;
 end;
/

==========================================
insert into bus_amnt values(7,'mathalai',15000);
 
insert into bus_amnt values(8,'mathu',16000);


 CREATE TABLE t1(id NUMBER);
 CREATE TABLE t2(id NUMBER);
 

 DROP TABLE t1;
 
 --statement level trigger(default trg |its fire for each event |IT  fire no rows are affected)
 CREATE OR REPLACE TRIGGER t1_trg 
 BEFORE INSERT OR UPDATE OR DELETE
 ON t1
 BEGIN 
  INSERT INTO t2 VALUES(1);
  END;
  /
  INSERT INTO t1 VALUES(10);
  INSERT INTO t1 VALUES(20);
  TRUNCATE TABLE t2;
  select rowid,id from t1;
  select * from t2;
  select COUNT(*) from t2;
  
  update t1
  set id=30 
  where rowid='AAAGQgAAEAAABs8AAC';
  



  DELETE FROM  t1;

 --row level trigger (for each row|if fire for each row affected by the event| it won't fire no rows are affected)
 
CREATE OR REPLACE TRIGGER t1_trg 
 BEFORE INSERT OR UPDATE OR DELETE
 ON t1
 FOR EACH ROW
 BEGIN 
  INSERT INTO t2 VALUES(:new.id);
  END;
  /
 

  INSERT INTO t1 VALUES(10);
  INSERT INTO t1 VALUES(20);
  INSERT INTO t1 VALUES(30);
  TRUNCATE TABLE t2;
  select * from t1;
  select * from t2;
  select COUNT(*) from t2;
  UPDATE t1 SET id200 WHERE id=10;
  
  DELETE  t1 WHERE id=500;
  
  --another one method
  
  CREATE OR REPLACE TRIGGER t1_trg 
 BEFORE INSERT OR UPDATE OR DELETE
 ON t1
 FOR EACH ROW
 BEGIN 
  INSERT INTO t2 VALUES(:new.id);
  END;
  //


  INSERT INTO t1 VALUES(10);
  INSERT INTO t1 VALUES(20);
  INSERT INTO t1 VALUES(40);
  
  TRUNCATE TABLE t1;
  TRUNCATE TABLE t2;
   
      select * from t1;
      select * from t2;
      select COUNT(*) from t2;
  UPDATE t1 SET id=200 WHERE id=10;
 
 
-- insert update delete

 CREATE OR REPLACE TRIGGER t1_trg 
 BEFORE INSERT OR UPDATE OR DELETE
 ON t1
 FOR EACH ROW
 --declare
  --counts number(5);
 BEGIN 
   IF INSERTING THEN
    INSERT INTO t2 VALUES(:new.id);
    ---  dbms_output.put_line('total count  '||counts);

   END IF;  
   IF UPDATING THEN
    UPDATE t2 SET id = :new.id WHERE id=:old.id;
      --dbms_output.put_line('total count  '||counts);
    
   END IF;

   IF DELETING THEN
   DELETE FROM  t2 WHERE id =:old.id;
    --dbms_output.put_line('total count  '||counts);
   END IF;
-- select count(*) into counts from t1;
  END;
  /

    INSERT INTO t1 VALUES(500);

    UPDATE t1 SET id=300 WHERE id=200;
       
    DELETE FROM t1 WHERE id =300;
      select * from t1;
      select * from t2;
````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
drop table emp_trg_tst;
create table emp_trg as (select first_name,department_id,salary from employees
                        where 1=2);
select * from emp_trg;          -------------------------------------1 tb

create table emp_trg_tst as (select first_name,department_id,salary from employees
 
                       where 1=2);
==============================================================================================
select * from emp_trg_tst;            -----------------------------2 tb    autiting
==============================================================================================
create or replace trigger trg_test    ---------------trg
before insert or update or delete
on emp_trg
for each row
begin
    if inserting then
       insert into emp_trg_tst values(:new.first_name,:new.department_id,:new.salary);
    end if;
    
    if updating then
      update emp_trg_tst 
      set salary=:new.salary
      where department_id=:new.department_id
      and first_name =:old.first_name;                ------- important......
    end if;
   if deleting then
    delete emp_trg_tst
    where first_name =:old.first_name;
  end if;
end;
/

insert into emp_trg values('gowri',10,10000);

-------------------------------
select first_name,department_id,salary from employees
where department_id =10;
---------------

insert into emp_trg  (select first_name,department_id,salary from employees
where department_id =10);

insert into emp_trg  (select first_name,department_id,salary from employees
where department_id =20);

insert into emp_trg  (select first_name,department_id,salary from employees
where department_id =30);


select * from emp_trg;         
select * from emp_trg_tst;         

--inserting success


update emp_trg
set salary=salary+600
where department_id=20;

----update success
 
delete emp_trg
where department_id=20;

---- delete success


      
--pragma autonomous transaction
      
--mutating error

CREATE TABLE s1(ref NUMBER PRIMARY KEY);
CREATE TABLE s2(ref NUMBER);
select * from s2;
drop table s1;


CREATE OR REPLACE TRIGGER s1_trg 
 BEFORE INSERT OR UPDATE OR DELETE
 ON s1
 FOR EACH ROW
 DECLARE 
 PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN 
  INSERT INTO s2 VALUES(:new.ref);
  commit;
  END;
  /


create table sun_tb (sun_id number(10));
truncate table sun_tb;
select * from sun_tb;
/
begin 
insert into sun_tb values(10);
insert into sun_tb values(20);
insert into sun_tb values(30);
insert into sun_tb values(40);
insert into sun_tb values(50);
insert into sun_tb values(60);
--commit;
sun_tb1;
commit;
end;
/

create or replace procedure sun_tb1
as
pragma autonomous_transaction;
begin
insert into sun_tb values(100);
insert into sun_tb values(200);
insert into sun_tb values(300);
insert into sun_tb values(400);
insert into sun_tb values(500);
insert into sun_tb values(600);
commit;
end;
/

rollback;


commit;
    INSERT INTO s1 VALUES(80);
    -- t1 ->1 t1->1 


update s1 
set ref=60
where ref=80;
select * from s1;
ROLLBACK;
    
--implementaation

CREATE OR REPLACE TRIGGER time_restr_trg
BEFORE INSERT OR UPDATE ON icici_trans_tb
  BEGIN
     IF TO_CHAR(SYSDATE,'d') IN (1,7) OR TO_CHAR(SYSDATE,'hh24:mi') NOT BETWEEN '9.00' AND '23.00' THEN
     --IF TO_CHAR(SYSDATE,'d') IN (1,7)THEN

       RAISE_APPLICATION_ERROR(-20004,'transaction not possible in this time');
     END IF;
  END time_restr_trg;
  /
  
  ------another try
  
CREATE OR REPLACE TRIGGER time_restr_trg
BEFORE INSERT OR UPDATE ON icici_trans_tb
  BEGIN
     IF TO_CHAR(SYSDATE,'d') IN (1,7) OR TO_CHAR(SYSDATE,'hh24:mi') NOT BETWEEN '9.00' AND '24.00' THEN
     --IF TO_CHAR(SYSDATE,'d') IN (1,7)THEN

dbms_output.put_line('date  :  '||TO_CHAR(SYSDATE,'d')||' time  :   '||TO_CHAR(SYSDATE,'hh24:mi'));
       RAISE_APPLICATION_ERROR(-20004,'transaction not possible in this time');
     END IF;
  END time_restr_trg;
  /
  
  
  
  select * from icici_trans_his;
CREATE TABLE icici_trans_tb (ref_id NUMBER);
INSERT INTO icici_trans_tb VALUES(10341);  
CREATE TABLE icici_trans_his (ref_id varchar2(200));

  
$$ we can create max 12 trg on table
$$  ALTER TRIGGER trg_name DISABLE;
$$  ALTER TRIGGER trg_name ENABLE;
$$  ALTER TABLE tble_name DISABLE ALL TRIGGERS;

LOGON ||AFTER timing
LOGOFF||BEFORE timing




11g features
fOLLOWS trg


we can organize the trg



-------------------------------------
ddl trigger with schema auditing
--------------------------------/


create table schema_audit
(
ddl_date date,
ddl_user varchar2(15),
object_cteated varchar2(15),
object_name varchar2(50),
ddl_operation varchar2(15)
);

drop table schema_audit purge;



create or replace trigger hr_audit_tr
after ddl  on schema
begin
insert into schema_audit values
(
sysdate, 
sys_context('USERENV','CURRENT_USER'),
ora_dict_obj_type,
ora_dict_obj_name,
ora_sysevent
);
end;
/

drop trigger hr_audit_tr;

select user from dual;
select sys_context('USERENV','CURRENT_USER') from dual;

select * from schema_audit;

create table sch_tbj(c_name varchar2(20));
insert into sch_tbj values('gowri');
insert into sch_tbj values('pathi');
insert into sch_tbj values('dhanya');
insert into sch_tb values('');

select * from sch_tb;

truncate table sch_tb;
alter table sch_tb modify c_name varchar2(20);

drop table sch_tb ;

create sequence seq_name;


-------------------------------------------------------
 database hr logon or logoff event trigger
--------------------------------------------------------

create table hr_event_audit
(
event_type varchar2(20),
username varchar2(10),
logon_date date,
logon_time varchar2(20),
logof_date date,
logof_time varchar2(20)
);
drop table hr_event_audit;

create or replace trigger hr__trg
after logon on schema
begin
insert into hr_event_audit values
(
ora_sysevent,
user,
sysdate,
to_char(sysdate,'hh24:mi:ss'),
null,
null
);
commit;
end;
/


disc;
conn hr/open;
conn system/open;

show huser;

select * from  hr_event_audit;
--------------------------------------------------


create or replace trigger hr_logoff_trg
before logoff on schema
begin
insert into hr_event_audit values
(
ora_sysevent,
user,
null,
null,
sysdate,
to_char(sysdate,'hh24:mi:ss')
);
commit;
end;
/

truncate table hr_event_audit;
select * from  hr_event_audit;

disc;
conn hr/open;
/


create or replace trigger db_logoff_trg
before logoff on database
begin
insert into hr_event_audit values
(
ora_sysevent,
user,
null,
null,
sysdate,
to_char(sysdate,'hh24:mi:ss')
);
end;
/
``````````````````````
--instead of triggers
``````````````````````
drop table emp;

drop table dept;
create table emp(id number(10),name varchar2(20),salary number(20),did number(10));
create table dept(did number(10),dname varchar2(20));


insert into emp (select employee_id,first_name,salary,department_id from employees where department_id in (10,20));
insert into dept(select department_id,department_name from departments);

drop table dept purge;

create or replace view emp_vw
as
select id,name,salary,did
from  emp ;

select * from emp_vw;
`
insert into emp_vw values(99,'letti',8500,15,'IF');

rollback;
select * from dept;
select * from emp;

create or replace view empdept_vw
as
select e.id,e.name,e.salary,e.did,d.dname
from  emp e,dept d
where d.did=e.did;

select * from empdept_vw;

insert into empdept_vw values(104,'ghanya',10000,15,'IFT');
/

delete empdept_vw where id =104;

create or replace trigger emp_trg1
instead of insert or delete on empdept_vw
for each row
declare
cnt number;
begin
if inserting then
   select count(*) into cnt from emp where id=:new.id;
   if cnt = 0 then
    insert into emp values(:new.id,:new.name,:new.salary,:new.did);
   end if;

   select count(*) into cnt from dept where did=:new.did;
   if cnt = 0 then
     insert into dept values (:new.did,:new.dname);
   end if;
end if;

if deleting then
   select count(*) into cnt from emp where id=:old.id;
   if cnt <> 0 then
   delete emp where id =:old.id; 
   end if;


   select count(*) into cnt from emp where did=:old.did;
   if cnt = 0 then
   delete dept where did =:old.did; 
   end if;


end if;

end;
/
select count(*) from dept where did=11;

   select count(*)from emp where did=15;

--------------------------------------------------------------------------------
create or replace trigger emp_trg1
instead of insert or delete on empdept_vw
for each row
declare
ed_cnt number(5);
begin

  select count(*) into ed_cnt from dept
  where did=:new.did;
if ed_cnt=0  then
   insert into dept(did,dname) values(:new.did,:new.dname); 
end if;

  select count(*) into ed_cnt from emp
  where id=:new.id;
if ed_cnt=0  then
   insert into emp(id,name,salary,did) values(:new.id,:new.name,:new.salary,:new.did); 
end if;
end;
/
--------------------------------------------------------------------------------

select count(*)   from dept
  where did=;

select * FROM dept;

insert into empdept_vw(id,name,salary,did,dname) values(210,'prya',20000,290,'IC');

dbms_output.put_line( 'dml operation happen...');
end;
/

select * from empdept_vw;
select * from emp;
select * from dept;

delete  emp
where id in(99,97,98,96,207,208,209,210);

delete  dept
where did in (280,290);
----------------------------------------------------------------------------------------------------------------------------------------------
1.  insted of trig mainly used for complex view to insertion
2.complex view means more than one base tb..
3. after the instd of trg creation 
   then execute any one insert stmn
   the inserted data only stored in base tables not in views bcoz this not updated view..
*/

/

CREATE OR REPLACE TRIGGER trg_validate1
BEFORE UPDATE OF salary ON emp_tb
FOR EACH ROW
DECLARE
 v_max_sal NUMBER(10):=100000;
BEGIN
        IF :new.salary < v_max_sal THEN
  INSERT INTO emp_upd_log  VALUES(:new.empno||'salary updated successfully' || 
                                'old sal :'||:old.salary||'new salary:'||:new.salary);
 
 ELSIF (:new.salary > v_max_sal and :new.job ='ceo') then
  INSERT INTO emp_upd_log VALUES(:new.empno||'ceo salary update successfully' || 
                                'old sal :'||:old.salary||'new salary:'||:new.salary);
ELSIF :new.salary >v_max_sal AND :new.job<> 'ceo' then
   :new.salary:=:old.salary ;
   INSERT INTO emp_upd_log VALUES(:new.empno||salary  not update successfully' || 
                                'old sal :'||:old.salary||'new salary:'||:new.salary);
ELSE
exit;

END IF;
END;
/



