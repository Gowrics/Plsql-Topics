---ref cursor


declare
cursor emp_off 
is
select first_name,department_id,manager_id from employees
where department_id=50;                                          ------1si cursor

cursor emp_prs 
is
select first_name,email,salary from employees
where salary >=20000;
v_alldata emp_prs%rowtype;                                    -------------2si cursor
begin
for i in emp_off
loop
dbms_output.put_line(i.first_name);
dbms_output.put_line(i.department_id);
dbms_output.put_line(i.manager_id);
dbms_output.put_line('_________');

end loop;
dbms_output.put_line('________________________________________________________________');

open emp_prs;
loop
 fetch emp_prs into v_alldata;
exit when emp_prs%notfound;
dbms_output.put_line(v_alldata.first_name);
dbms_output.put_line(v_alldata.email);
dbms_output.put_line(v_alldata.salary);
end loop;
end;
/
____________________________________________________________________________________________________________/

declare
type sal_ref is ref cursor;
sals sal_ref;
v_name employees%rowtype;
v_dname departments%rowtype;
begin
open sals for select * from employees;
loop
fetch sals into v_name;
exit when sals%notfound;
dbms_output.put_line('name  :   '||rpad(v_name.first_name,9,' ')||'   '||v_name.employee_id||'   '||sals%rowcount);
end loop;
close sals;
open sals for select * from departments;
loop
fetch sals into v_dname;
exit when sals%notfound;
dbms_output.put_line('name  :   '||rpad(v_dname.department_name,9,' ')||'   '||sals%rowcount);
end loop;
close sals;
end;
/

--strongly type ref cursor

declare
type strg_ref is ref cursor return locations%rowtype;
loc strg_ref ;
locat locations%rowtype;
begin
open loc for select * from locations;
loop
fetch loc into locat;
exit when loc%notfound;
dbms_output.put_line(locat.location_id);
end loop;
end;
/
````````````````````````````````````````````````````````````````````````````````````````````````````````````````
--no type declaration needed 
declare
loc sys_refcursor;
locat locations%rowtype;
begin
open loc for select * from locations;
loop
fetch loc into locat;
exit when loc%notfound;
dbms_output.put_line(locat.city);
end loop;  
end;
/

select * from reservation_seats
where train_name='KAVERI EXPRESS';

declare 
seats_avail sys_refcursor;
reserv_seats reservation_seats%rowtype;
begin
open seats_avail for select * from reservation_seats
where train_name='VAIGAI EXP ';
loop
fetch seats_avail into reserv_seats;
exit when seats_avail%notfound;
dbms_output.put_line(reserv_seats.train_name ||reserv_seats.seats||'---'||nvl(reserv_seats.available_seats,0));
end loop;
end;
/
VAIGAI EXP     

--------------------------------------------------------------------------

create or replace procedure sp_ref(r out sys_refcursor) 
as
begin
open r for select first_name ,salary from employees;
end;
/
--declare bind variable
variable r refcursor
exec sp_ref(:r);
print r;

/*
create or replace type ep_rec is record (name varchar2(20),salary number(20));
/
show error;
create or replace type colref is table of ep_rec;
/
*/


create or replace procedure sp_col
as
m sys_refcursor;
type ep_rec is record(name varchar2(20),salary number);
type colref is table of ep_rec;
n colref;
begin
sp_ref(m);
loop
fetch m bulk collect into n;
close m;
dbms_output.put_line(n.count);
end;
/

exec sp_col;

set serveroutput on;




create or replace type e_obj is object(eid number,ename varchar2(30)); --handle multiple colmn
/

create or replace type e_clc is table of e_obj;  --handle multiple row
/

create or replace procedure sp_col(e_cv in e_clc,pmsg out varchar2)
as
begin
for i in 1..e_cv.count
loop
insert into dctr values(e_cv(i).eid,e_cv(i).ename);
commit;
pmsg:='insert opr done here';
end loop;
dbms_output.put_line(pmsg);
end;
/

declare
e_cv  e_clc;
pmsg varchar2(100);
begin
e_cv:=e_clc(e_obj(10,'raj'),e_obj(11,'taj'),e_obj(12,'saj'),e_obj(13,'baj'),e_obj(14,'maj'),e_obj(15,'faj'));
sp_col(e_cv,pmsg);
end;
/

select * from dctr;
truncate table dctr;\


14.Can we use any PL/SQL datatypes for declaring our Strong Ref Cursor?
    No, we cannot. The return type of a strong ref cursor must always be a Record Datatype. 
    It can either be a Table Based Record datatype or a User Defined Record Datatype.
	
