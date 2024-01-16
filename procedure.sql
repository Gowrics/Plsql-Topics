

/*store procedure(-sp)
-named plsql sub program stored in database
-repeated usage
-parameter mode--> in out inout
-dict table
     -user_procedures
     -user_sourece
     user_errors
*/

DECLARE
 v_a NUMBER:=10; 
 v_b NUMBER:=20;
 v_c  NUMBER;
 BEGIN
 v_c:= v_a + v_b;
 dbms_output.put_line(v_c);
 END;
 /
 --tis query temparury stored
 
--procedure creation 
 CREATE OR REPLACE PROCEDURE add_sum
 AS
 v_a   NUMBER:=10; 
 v_b   NUMBER:=20;
 v_c   NUMBER;
 BEGIN
 v_c := v_a + v_b;
 dbms_output.put_line(v_c);
 END add_sum;
 /
--execution part
BEGIN
   add_sum;
END;
/

EXEC add_sum;
--parameter pass IN mode

 CREATE OR REPLACE PROCEDURE add_sum(p_a IN NUMBER,p_b IN NUMBER)
 AS
 p_a   NUMBER:=10; 
 p_b   NUMBER:=20;
 v_c   NUMBER;
 BEGIN
 v_c := p_a + p_b;
 dbms_output.put_line(v_c);
 END add_sum;
 /
cl scr;
-- procedure create but having error
--how will u view error msg in plsql   
show errors;
SELECT text FROM  user_errors WHERE name ='ADD_SUM';

--passing arg is same as declaraton so no need to declare

 CREATE OR REPLACE PROCEDURE add_sum(p_a IN NUMBER,p_b IN NUMBER)
 AS
v_c NUMBER;
 BEGIN
 v_c := p_a + p_b;
 dbms_output.put_line(v_c);
 END add_sum;
 /
BEGIN
add_sum(103,290);
END;
/
--in procedure we cannot use dbms
--use 3 parameter IN OR OUT
 CREATE OR REPLACE PROCEDURE add_sum(p_a IN NUMBER,p_b IN NUMBER,p_c OUT NUMBER)
 AS
 BEGIN 
 p_c := p_a + p_b;
 END add_sum;
 /
 --exec part
 
DECLARE
v_a   NUMBER :=10; 
v_b   NUMBER :=10;
v_c   NUMBER ;
BEGIN
add_sum(v_a,v_b,v_c);
 dbms_output.put_line(v_c);
END;
/

--phone format
--2783267676 ->(278)326-7676

CREATE OR REPLACE PROCEDURE phone_format_sp (p_no IN OUT VARCHAR2)
AS
BEGIN
p_no := '(' ||SUBSTR(p_no,1, 3)||
        ')' ||SUBSTR(p_no,4, 3)||
        '_' ||SUBSTR(p_no,7,4);
END phone_format_sp;
/
declare
v_ph_no VARCHAR2(500);
BEGIN 
phone_format_sp('9876712345');
dbms_output.put_line('phone number  :'||v_ph_no);
END;
/



DECLARE
v_ph_no VARCHAR2(30):='7657893456 '; 
BEGIN 
phone_format_sp(v_ph_no);
dbms_output.put_line('phone number  :'||v_ph_no);
END;
/

--example 2

CREATE OR REPLACE PROCEDURE phone_format_sp (p_no IN OUT VARCHAR2
                                             ,p_status OUT VARCHAR2
                                             ,p_err_msg OUT VARCHAR2)
AS
abort_ex EXCEPTION;
BEGIN
   IF LENGTH(p_no)<>10 THEN
      RAISE abort_ex;
   END IF;
p_no := '(' ||SUBSTR(p_no,1, 3)||
        ')' ||SUBSTR(p_no,4, 3)||
        '_' ||SUBSTR(p_no,7,4);

    p_status:= 's'; 
    p_err_msg := p_no||'      valid ph number';
EXCEPTION
  WHEN abort_ex THEN 
    p_status  := 'f';
    p_err_msg := p_no||'    this is not valid ph number';
END phone_format_sp;
/



DECLARE
v_ph_no VARCHAR2(30):='766345734368'; 
v_status VARCHAR2(30);
v_err VARCHAR2(200);
BEGIN 
phone_format_sp(v_ph_no,v_status,v_err);
 /* SELECT DECODE (v_status,'s' ,'success' 
                             ,'failure')
        , NVL(v_err,'No Error')INTO v_status,v_err FROM dual;
   IF v_status ='success' THEN
     dbms_output.put_line('phone number  :'||v_ph_no);   
   END IF;
    dbms_output.put_line('status        :'||v_status);
    dbms_output.put_line('error msg     :'||v_err);
    */
     dbms_output.put_line('phone number  :'||v_ph_no);   
    dbms_output.put_line('status        :'||v_status);
    dbms_output.put_line('error msg     :'||v_err);

END;
/
SELECT * FROM user_source WHERE name='PHONE_FORMAT_SP';
SELECT * FROM user_source;

CREATE OR REPLACE PROCEDURE expansive_det
AS
sum_dept NUMBER;
BEGIN
SELECT max(SUM(salary)) INTO sum_dept FROM employees GROUP BY department_id;
     dbms_output.put_line('tot salary  :'||sum_dept);   
END;
/
BEGIN 
 expansive_det;
END;
/
````````````````````````````````````````````````````````````````````
      pls remove space on ph numph number 
````````````````````````````````````````````````````````````````````
CREATE OR REPLACE PROCEDURE ph_num(v_phnum IN VARCHAR2,v_number IN OUT NUMBER)
AS  
err_han EXCEPTION;
BEGIN
v_number:=SUBSTR(v_phnum,1,(INSTR(v_phnum,' '))-1)||
          SUBSTR(v_phnum,(INSTR(v_phnum,' '))+1);   
    dbms_output.put_line(v_number);
IF LENGTH(v_number)<>10 THEN
 RAISE err_han;
END IF;
EXCEPTION 
 WHEN err_han THEN
     dbms_output.put_line('your phone number length is  :'||LENGTH(v_number));
     dbms_output.put_line('pls enter 10 digit of ph number');
 END;
/
exec ph_num('983765363',9);


select SUBSTR('393836333',1,(INSTR('393836333   ',' '))-1)||
          SUBSTR('393836333',(INSTR('393836333',' '))+1)   
from dual;

--1st method
 
 DECLARE
c_dpid NUMBER ;
c_tot NUMBER ;
CURSOR max_dept
IS
SELECT department_id,SUM(salary) 
     FROM employees GROUP BY department_id
     HAVING SUM(salary)>10000
     ORDER BY 1;
BEGIN

OPEN max_dept;
LOOP
FETCH max_dept 
INTO c_dpid,c_tot;
 EXIT WHEN max_dept%NOTFOUND;
 dbms_output.put_line('counting  :'||max_dept%ROWCOUNT);   
 dbms_output.put_line('dept  id  :'||c_dpid);   
 dbms_output.put_line('max salary  :'||c_tot);  
 EXIT WHEN max_dept%NOTFOUND;
 END LOOP;
END;
/

--2nd method

 DECLARE
CURSOR max_dept
IS
SELECT department_id,SUM(salary) tot_sal 
     FROM employees GROUP BY department_id
     HAVING SUM(salary)>=10000
     ORDER BY 1;
BEGIN
 FOR i IN max_dept
 LOOP
 dbms_output.put_line('counting  :'||max_dept%ROWCOUNT);   
 dbms_output.put_line('dept  id  :'||i.department_id);   
 dbms_output.put_line('sum salary  :'||i.tot_sal);  
 END LOOP;
END;
/
--without declare
BEGIN
 FOR i IN (SELECT department_id,SUM(salary) tot_sal 
     FROM employees GROUP BY department_id
     HAVING SUM(salary)>=10000
     ORDER BY 1)
 LOOP
 dbms_output.put_line('dept  id  :'||i.department_id);   
 dbms_output.put_line('sum salary  :'||i.tot_sal);  
 END LOOP;
END;
/


 declare
 
PROCEDURE add_sum(p_a IN OUT NUMBER)                      ---1
 AS
 BEGIN
 p_a:=MOD(p_a,2);
 IF p_a=0 THEN
 dbms_output.put_line('EVEN NUMBER');
 ELSE
 dbms_output.put_line('ODD NUMBER');
 END IF;
 END add_sum;
 
PROCEDURE add_sum(p_b in number,p_a IN OUT NUMBER)         ----2
AS
BEGIN
p_a :=p_a+p_b; 

dbms_output.put_line('TOTAl NUMBER  :'||p_a);
END add_sum;
v_a number:=120;
v_a1 number:=200;

begin
add_sum(v_a);
add_sum(140,v_a1);
end;
/

 
DECLARE
v_a NUMBER:=&number;
v_b NUMBER:=&number;

BEGIN
add_sum(v_a,v_b);
END;
/


set serveroutput on;
---------------------------------------------------------------------------------------------------------------------------
=================================================overloading concept============================================================

overloading is we create one or more proc with same name but differents is in the parameters.
the diff is could be very small. the para mtr position can be chang or data type or change.
when we use

The difference could be very small, such as that one of the parameters has a different data type.




create or replace package overloading_pkg
as
procedure display_result(p_lower in number,p_upper in number);
--procedure display_result(v1 in number,v2 in number,v3 in number);
function display_result(v1 in number,v2 in number,v3 in number) return number;

procedure display_result(v1 varchar2,v2 varchar2);
end;
/

create or replace package body overloading_pkg
as
procedure display_result(p_lower in number,p_upper in number)
as
begin
dbms_output.put_line('first procedure');
for i in p_lower..p_upper
loop
dbms_output.put_line(i);
end loop;
end;

function display_result(v1 in number,v2 in number,v3 in number) return number
as
begin
dbms_output.put_line('second procedure');
return v1+v2+v3;
end;

/*
procedure display_result(v1 in number,v2 in number,v3 in number)
as
begin
dbms_output.put_line('second procedure');
dbms_output.put_line(v1+v2+v3);
end;
*/
procedure display_result(v1 varchar2,v2 varchar2)
as
begin
dbms_output.put_line('third procedure');
dbms_output.put_line(v1 || ' and  '||v2);

end;
end;
/

exec overloading_pkg.display_result(10,20);
exec overloading_pkg.display_result(1,2,3);
exec overloading_pkg.display_result('good','morning');

select overloading_pkg.display_result(1,2,3) from dual;

declare
v_out number;
begin
overloading_pkg.display_result(10,20);
--overloading_pkg.display_result(1,2,3);
overloading_pkg.display_result('good','morning');
select overloading_pkg.display_result(1,2,3) into v_out from dual;
dbms_output.put_line(v_out);

end;
/  ------------------success


declare 
datein date;
numberin number;
function value_ok (date_in in date) return boolean
is
begin
return date_in <= sysdate;
end;
function value_ok (number_in in number) return boolean
is
begin
return number_in = 0;
end;
procedure value_ok (number_in in number) 
is
begin
if number_in >50 then
dbms_output.put_line(number_in|| 'its ok...' );
else 
dbms_output.put_line(number_in|| 'its not ok...' );
end if;
end;

begin
if value_ok('20-oct-23')=false 
then
dbms_output.put_line('function date ok');
end if;

if value_ok(50) =true 
then
dbms_output.put_line('function number ok');
end if;
value_ok(23);
end;
/              --this is accur error





