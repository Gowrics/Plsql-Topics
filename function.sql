-- function


CREATE OR REPLACE PROCEDURE add_sp(p_a IN NUMBER,p_b IN NUMBER,p_c OUT NUMBER)
AS
BEGIN
p_c := p_a + p_b;
END add_sp;
/
DECLARE
v_a number :=140;
v_b number :=160;
v_c number;
BEGIN
add_sp(v_a,v_b,v_c);
dbms_output.put_line(v_c);
END;
/
--functiom
CREATE OR REPLACE FUNCTION add_sf(p_a IN NUMBER,p_b IN NUMBER,p_y IN NUMBER)    --st:2
RETURN NUMBER                              --st:2
AS
v_c  NUMBER;
BEGIN
v_c := p_a + p_b + p_y;
RETURN v_c;                                --st:3
END add_sf;
/
SELECT add_sf(100,100,100) FROM dual;
SELECT salary,add_sf(salary,100,50) FROM employees;

CREATE OR REPLACE FUNCTION emp_val_fn(p_emp_id IN OUT NUMBER)
RETURN NUMBER 
AS
v_name VARCHAR2(30);
BEGIN
  SELECT first_name INTO v_name FROM employees WHERE employee_id=p_emp_id; 
     RETURN p_emp_id;
EXCEPTION 
  WHEN no_data_found THEN
     RETURN p_emp_id;
END emp_val_fn;
/
DECLARE 
v_id NUMBER:=100;
BEGIN
   IF emp_val_fn(v_id)=1 THEN 
    dbms_output.put_line('valid emp number     :');
    ELSE
    dbms_output.put_line('Invalid ph number');
    END IF;
END;
/



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



set serveroutput on;



create or replace function retun_fn(a1 in number,a2 in number,sums in out varchar2) return varchar2
as
c1  number;
c2 number;
begin
c2 := a1 - a2;
c1 := a1 + a2;
sums:='sum : '||c1||'sub :'||c2;
--dbms_output.put_line(sums);
return sums  ;
end;

/

declare
a number:=20;
b number:=24;
sums varchar(100);
ret varchar2(100);
begin
select retun_fn(a,b,sums) into ret from dual;
end;
/


if  retun_fn(a,b,c,d) = 0
then 
dbms_output.put_line('null');
else 
dbms_output.put_line('not null'||c||d);

end if;
--select retun_fn(a,b,d) from dual;
end;
/