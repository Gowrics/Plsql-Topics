--index by table bulk collect into collection and display one by one using for loop
DECLARE
      TYPE arr_val IS TABLE OF departments%rowtype
          INDEX BY binary_integer;
      a arr_val:=arr_val();
BEGIN
    select * bulk collect INTO a FROM departments;
    FOR i IN a.first..a.last
    LOOP
      dbms_output.put_line(a(i).department_name||a(i).department_id);
    END LOOP;
    END;
    /
----------------------------------------------------------------------------------
 -- nested array      fetch the data to nested coll type and insert into another table .
 create  table department_emp(dept_id number,dept_name varchar2(30));
select * from department_emp;

rollback;
 DECLARE
  TYPE t_bulk_collect_test_tab IS TABLE OF departments%ROWTYPE;

  l_tab    t_bulk_collect_test_tab := t_bulk_collect_test_tab();
  l_start  NUMBER:=0;
BEGIN
  --  regular population.

  l_start := l_start+1 ;
  FOR cur_rec IN (SELECT *
                  FROM  departments)
  LOOP
    l_tab.extend;
    l_tab(l_tab.last) := cur_rec;
dbms_output.put_line(l_tab(l_tab.last).department_name); --insert last and dispaly last one by one. 
  END LOOP;

  --  bulk population.  (BULK COLLECT)
  SELECT *
  BULK COLLECT INTO l_tab
  FROM   departments;
-- use of FORALL 
-- insert bulk and update bulk
forall i in l_tab.first..l_tab.last
insert into department_emp values(l_tab(i).department_id,l_tab(i).department_name);
--
forall i in l_tab.first..l_tab.last
update department_emp
set dept_name =upper(dept_name)
where dept_id= l_tab(i).department_id ;
commit;
END;
/
select * from department_emp;

truncate table department_emp;


----------------------------------------------------------------------------------------------------------------
--varray using datatype(varchar2,type)  
declare
type emp_name is varray(100) of varchar2(20);
nam emp_name :=emp_name(99);
begin
nam.extend(99);
select first_name bulk collect into nam from employees
where rownum <=100
order by employee_id;
dbms_output.put_line(nam.first || nam.count ||nam.last);
for i in nam.first..nam.last
loop
 dbms_output.put_line(i||' employee is  : '||nam(i));
end loop;
end;
/
------------------------------------------------------------------------
--varray using datatype rowtype

declare
type emp_name is varray(30) of employees%rowtype;
nam emp_name;

begin
nam:= emp_name();
nam.extend(29);
select * bulk collect into nam from employees
where rownum <=30
order by employee_id;
dbms_output.put_line(nam.first || nam.count ||nam.last);
for i in nam.first..nam.last
loop
 dbms_output.put_line(rpad(nam(i).first_name,10,' ') ||'   '||nam(i).salary);
end loop;
end;
/
set serveroutput on;

FORALL
The FORALL syntax allows us to bind the contents of a collection to a single DML statement, allowing the DML to be run for each row in the collection without requiring a context switch each time. To test bulk binds using records we first create a test table.
/

select * from forall_test;

CREATE TABLE forall_test (
  id           NUMBER(10),
  code         VARCHAR2(10),
  description  VARCHAR2(50));

ALTER TABLE forall_test ADD (
  CONSTRAINT forall_test_pk PRIMARY KEY (id));

ALTER TABLE forall_test ADD (
  CONSTRAINT forall_test_uk UNIQUE (code));
The following test compares the time taken to insert 10,000 rows using regular FOR..LOOP and a bulk bind.

SET SERVEROUTPUT ON
DECLARE
  TYPE t_forall_test_tab IS TABLE OF forall_test%ROWTYPE;

  l_tab    t_forall_test_tab := t_forall_test_tab();
  l_start  NUMBER;
  l_size   NUMBER            := 50;
BEGIN
  -- Populate collection.
  FOR i IN 1 .. l_size LOOP
    l_tab.extend;

    l_tab(l_tab.last).id          := i+10;
    l_tab(l_tab.last).code        := TO_CHAR(i);
    l_tab(l_tab.last).description := 'PRD_' || TO_CHAR(i);
  END LOOP;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE forall_test';

  -- Time bulk inserts. 
  l_start := DBMS_UTILITY.get_time;

  FORALL i IN l_tab.first .. l_tab.last
    INSERT INTO forall_test VALUES l_tab(i);

  COMMIT;
END;
/
select * from forall_test;
---------------------------------------

DECLARE
 -- TYPE t_id_tab IS TABLE OF forall_test.id%TYPE;
  TYPE t_forall_test_tab IS TABLE OF forall_test%ROWTYPE;

--  l_id_tab  t_id_tab          := t_id_tab();
  l_tab     t_forall_test_tab := t_forall_test_tab ();
  l_start   NUMBER;
  l_size    NUMBER            := 25;
BEGIN
  -- Populate collections.
  FOR i IN 1 .. l_size LOOP
  --  l_id_tab.extend;
    l_tab.extend;

    --l_id_tab(l_id_tab.last)       := i+10;
    l_tab(l_tab.last).id          := i+10;
    l_tab(l_tab.last).code        := TO_CHAR(i);
    l_tab(l_tab.last).description := 'Desc: ' || TO_CHAR(i);

  END LOOP;

  -- Time bulk updates.
  FORALL i IN l_tab.first .. l_tab.last
    UPDATE forall_test
    SET    description= l_tab(i).description
    WHERE  id  = l_tab(i).id;
  COMMIT;
END;
/

------------------LIMIT EXAMPLE----------------------------
--limit cls is restrict th enum of rows fetching in bulk collect.

--only in  using bulk collect with fetch into stmnt.
DECLARE
  TYPE t_bulk_collect_test_tab IS TABLE OF departments%ROWTYPE;
  l_tab t_bulk_collect_test_tab;

  CURSOR c_data IS
    SELECT *
    FROM departments;
BEGIN
  OPEN c_data;
  LOOP
    FETCH c_data
    BULK COLLECT INTO l_tab LIMIT 20;

--     Process contents of collection here.
  DBMS_OUTPUT.put_line(l_tab.count || ' rows');
  
  EXIT WHEN l_tab.count = 20;

  END LOOP;
  CLOSE c_data;
END;
/


declare
type limit_example is table of employees%rowtype
index by binary_integer;
limit_ex limit_example;
cursor emp_ex is
select * from employees;

begin
open emp_ex;
loop
fetch emp_ex bulk collect into limit_ex LIMIT 100;
    DBMS_OUTPUT.put_line(limit_ex.count);
EXIT WHEN limit_ex.count = 100;
end loop;
close emp_ex;
for i in limit_ex.first..limit_ex.last
loop
    DBMS_OUTPUT.put_line(limit_ex(i).first_name||limit_ex(i).salary);
end loop;

end;
/
---------------------------------exception----------------------------

create table emps1(ids number,names varchar2(20));
create table emps(ids number primary key,names varchar2(20));
insert into emps1 values(1,'raj');
insert into emps1 values(2,'gaj');
insert into emps1 values(2,'vaj');
insert into emps1 values(3,'haj');
insert into emps1 values(1,'raj');
select * from emps;
/
declare 
type emps_err is table of emps%rowtype
index by binary_integer;
emp emps_err;
 l_error_count  NUMBER;
handle_ex exception;
pragma exception_init(handle_ex,-24381);
begin
EXECUTE IMMEDIATE 'TRUNCATE TABLE emps';

select * bulk collect into emp from emps1;


for i in emp.first..emp.last
loop
dbms_output.put_line(emp(i).ids||emp(i).names);
end loop;
  
forall  i in emp.first..emp.count save exceptions
 insert into emps values(emp(i).ids,emp(i).names);
commit;

  EXCEPTION
    WHEN handle_ex THEN
      l_error_count := SQL%BULK_EXCEPTIONS.count;
      DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
      FOR i IN 1 .. l_error_count LOOP
        DBMS_OUTPUT.put_line('Error: ' || i ||
          ' Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
 
          ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
      END LOOP;  
end;
/
drop table emps;


select * from exception_test;
DECLARE
  TYPE t_tab IS TABLE OF exception_test%ROWTYPE;

  l_tab          t_tab := t_tab();
  l_error_count  NUMBER;
 
  ex_dml_errors EXCEPTION;

  PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
BEGIN
  -- Fill the collection.
  FOR i IN 1 .. 100 LOOP
    l_tab.extend;
    l_tab(l_tab.last).id := i;
  END LOOP;

  -- Cause a failure.
  l_tab(50).id := NULL;
  l_tab(51).id := NULL;
 
  EXECUTE IMMEDIATE 'TRUNCATE TABLE exception_test';

  -- Perform a bulk operation.
  BEGIN
    FORALL i IN l_tab.first .. l_tab.last SAVE EXCEPTIONS
      INSERT INTO exception_test
      VALUES l_tab(i);
  EXCEPTION
    WHEN ex_dml_errors THEN
      l_error_count := SQL%BULK_EXCEPTIONS.count;
      DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
      FOR i IN 1 .. l_error_count LOOP
        DBMS_OUTPUT.put_line('Error: ' || i ||
          ' Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
 
          ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
      END LOOP;
  END;
END;
/

Number of failures: 2
Error: 1 Array Index: 50 Message: ORA-01400: cannot insert NULL into ()
Error: 2 Array Index: 51 Message: ORA-01400: cannot insert NULL into ()
=========================================================================================================================================



--index  by table


DECLARE
 TYPE color_arry_code IS TABLE OF VARCHAR2(30)
                                INDEX BY VARCHAR2(10);
 code color_arry_code;
BEGIN
 code('red')   :='000,111,010';
 code('green') :='000,222,020';
 code('blue')  :='000,333,030';
 code('yellow'):='000,333,030';
 code('pink')  :='000,444,040';
-- code.extend(1);                     only in varray and nested tb i think
--code.trim('pink');           
code.delete ('pink');
code.delete;

      dbms_output.put_line(code('red'));
      dbms_output.put_line(code('green'));
      dbms_output.put_line('count   '||code.count);
      dbms_output.put_line('first  '||code.first);
      dbms_output.put_line('last   '||code.last);
      dbms_output.put_line('prior   '||code.prior('yellow'));
      dbms_output.put_line('next   '||code.next('blue'));

--      dbms_output.put_line(code.limit);       -- index type is varchar2 so occur error.. limit return null 
if code.exists('blue') then                 --- ----uninit
      dbms_output.put_line('yess..........');
else
      dbms_output.put_line('no............');
end if;


END;
/

--varray table

 DECLARE 
  TYPE dys_elem IS VARRAY(7) OF VARCHAR2(10);
  v_day dys_elem := dys_elem();
BEGIN 
v_day.extend(7);
v_day(1):='sunday';
v_day(2):='monday';
v_day(3):='tuesday';
v_day(4):='wednesday'; 
v_day(5):='thursday';
v_day(6):='friday';
v_day(7):='saturday'; 
  dbms_output.put_line(v_day(1));
  dbms_output.put_line(v_day(2));
  dbms_output.put_line(v_day(3));
  dbms_output.put_line(v_day(4));
  dbms_output.put_line(v_day(5));
  dbms_output.put_line(v_day(6));
  dbms_output.put_line('lm  '||v_day.limit);
  dbms_output.put_line('cnt  '||v_day.count);
  dbms_output.put_line('1st  '||v_day.first);
  dbms_output.put_line('last  '||v_day.last);
  dbms_output.put_line('prior  '||v_day.prior(4));
  dbms_output.put_line('next  '||v_day.next(4));
 -- v_day.delete(4);
  v_day.trim;
  dbms_output.put_line('cnt  '||v_day.count);
  v_day.trim(1);
  dbms_output.put_line('cnt  '||v_day.count);


if v_day.exists(7) then                 --- ----uninit
      dbms_output.put_line('yess..........');
else
      dbms_output.put_line('no............');
end if;
    v_day.delete;
  --v_day.delete(1);   not work
  dbms_output.put_line('cnt  '||v_day.count);



END;
/

--nested table

 DECLARE 
  TYPE nst_elem IS TABLE OF VARCHAR2(10);
  v_day nst_elem := nst_elem(null,null,null);
BEGIN 
 v_day(1):='sunday';
 v_day(2):='monday';
 v_day(3):='tuesday';
v_day.delete(2);
 dbms_output.put_line(v_day(1));
-- dbms_output.put_line(v_day(2));
 dbms_output.put_line(v_day(3));
 dbms_output.put_line(v_day.count);
 dbms_output.put_line(v_day.first);
 dbms_output.put_line(v_day.last);
 dbms_output.put_line(v_day.prior(3));
 dbms_output.put_line(v_day.next(1));
IF v_day.exists(2) THEN
 dbms_output.put_line(v_day(2));
ELSE
 dbms_output.put_line('2 not exists......');
END IF;
v_day.delete;
 dbms_output.put_line(v_day.count);
END;
/
________________________________________________________________________________________________________________________--/



--collection
 collection is ordered group of elements having same data type.
 each elements identyfied by unique index value that position in the collection.
--   1,pl/sql table or index by table
--   2,varray
--   3,nested table
``````````````````````````````````````````````/
--1.plsql tb IN 7 or index by table 8I or associative array 9I
--use plsql tb
--declare type and declare variable, stroe value 


DECLARE
      TYPE arr_val IS TABLE OF VARCHAR2(20)
          INDEX BY binary_integer;
      a arr_val;  
      BEGIN
    FOR i IN 1..20
    LOOP
        select department_name into a(i) FROM departments WHERE department_id=i*10;
    END LOOP;
    FOR i IN 1..20
    LOOP
      dbms_output.put_line(a(i));
    END LOOP;
     dbms_output.put_line('lm  :  '||a.limit);

    END;
    
    /
    
-----------------------------------------------------------------------/

DECLARE
      TYPE arr_val IS TABLE OF VARCHAR2(20)
          INDEX BY binary_integer;
      a arr_val;  
      BEGIN
      a(1):='admin';
      a(2):='market';
      a(3):='purchase';
      a(4):='hr';
      a(5):='sales';
      a(6):='exec';

      FOR i IN 1..6
    LOOP
      --    dbms_output.put_line(a(i));
    dbms_output.put_line(a(a.first));
    dbms_output.put_line(a(a.count));
    END LOOP;
    END;
    /





set serveroutput on;
--another ex we dont need to declare another loop
DECLARE
      TYPE arr_val IS TABLE OF VARCHAR2(20)
          INDEX BY VARCHAR2(10);
      a arr_val;
      b NUMBER(10):=0;
BEGIN
    FOR i IN 1..20
    LOOP
    b:=b+1;
    select department_name into a(i) FROM departments WHERE department_id=b*10;
    --END LOOP;
    --FOR i IN 1..20
    --LOOP
      dbms_output.put_line('index val:'||i||'  '||a(i));
    END LOOP;
    END;
    /
--example




DECLARE
 TYPE color_arry_code IS TABLE OF VARCHAR2(30)
                                INDEX BY VARCHAR2(10);
 code color_arry_code;
BEGIN
 code('red')   :='000,111,010';
 code('green') :='000,222,020';
 code('blue')  :='000,333,030';
 code('yellow'):='000,333,030';
 code('pink')  :='000,444,040';
      dbms_output.put_line(code('red'));
      dbms_output.put_line(code('green'));
      dbms_output.put_line(code('blue'));
      dbms_output.put_line(code('yellow'));
      dbms_output.put_line(code('pink'));
      dbms_output.put_line(code.count);

END;
/
--using 2 array 

create or replace procedure days_p(p_outmsg out varchar2)
as 
type day_name is table of varchar2(30)
  index by varchar2(10);
day day_name;
begin
day(1):='sunday';
day(2):='monday';
day(3):='tuesday';
day(4):='wednesday';
day(5):='thursday';
day(6):='friday';
day(7):='saturday';
for i in 1..7 
loop
p_outmsg:=p_outmsg||'/'||day(i);
end loop;
end;
/

declare
v_out varchar2(300);
begin
days_p(v_out);
dbms_output.put_line(v_out);

end;
/



DECLARE
      TYPE arr_val IS TABLE OF VARCHAR2(20)
          INDEX BY binary_integer;
   
      TYPE arr_val1 IS TABLE OF NUMBER(20)
          INDEX BY binary_integer;
   
      a arr_val;
      b arr_val1;
      
BEGIN
    FOR i IN 1..27
    LOOP
    select department_name,department_id into a(i),b(i) FROM departments WHERE department_id=i*10;
    END LOOP;
    FOR i IN 1..27
    LOOP
      dbms_output.put_line(a(i)||'_'||b(i));
    END LOOP;
    
    END;
    /
set serveroutput on;
```````````````````````````````````````````````````````````/
select * FROM departments;
--department_id=i*10; to avoid this use BULK COLLECT



DECLARE
      TYPE arr_val IS TABLE OF VARCHAR2(20)
          INDEX BY binary_integer;
      a arr_val;
BEGIN
    select department_name bulk collect INTO a FROM departments;
    FOR i IN a.first..a.last
    LOOP
      dbms_output.put_line(a(i));
    END LOOP;
    END;
    /

 DECLARE
      TYPE dep_name IS TABLE OF VARCHAR2(20)
          INDEX BY binary_integer;
      TYPE dep_id IS TABLE OF VARCHAR2(20)
          INDEX BY binary_integer;
     
           a dep_name;
           b dep_id;
BEGIN
    select department_name,department_id bulk collect INTO a,b FROM departments;
    --FOR i IN a.first..a.last
    --LOOP
      dbms_output.put_line(a(10)||'---->'||b(10));
    --END LOOP;
    END;
    /

 
 
 
 --BULK BIND'
 select * from emp;
  -- in this method plsql engin and sql engil are work together collection is plsql eng and update is sql eng 
  --this is called context switch
  
  --if the context switch increase,the performnce decrease
  -- so we use bulk bind 
 DECLARE 
 TYPE upd_arry IS TABLE OF emp.employee_id%TYPE
           INDEX BY binary_integer;
 up upd_arry;
 BEGIN 
 SELECT employee_id BULK COLLECT INTO up FROM emp;
 FOR i IN up.first..up.last
 LOOP
 UPDATE emp 
 SET salary =salary+10
 WHERE employee_id=up(i);
 END LOOP;
 END;
 /
-- bulk bind 
 -- use FORALL LOOp
 
DECLARE 
 TYPE upd_arry IS TABLE OF emp.emp_id%TYPE
           INDEX BY binary_integer;
 up upd_arry;
 BEGIN 
 SELECT emp_id BULK COLLECT INTO up FROM emp;
 FORALL i IN up.first..up.last
 UPDATE emp 
 SET salary =salary+10
 WHERE emp_id=up(i);
 END;
 /
 
 
 
 select * FROM emp;
 --diff b/w cursor nd collection
--       CURSOR                              COLLECTION 
         ------                              ----------
--fetch row by row                          fetch all the row
--less memory allocation                    more memory allocation
--poor perf                                 good perf 
--cannot move to backward row               can move forward rw and backword rw
--does nt supprt random access              support random access. 
 
  DECLARE
      TYPE dep_name IS TABLE OF VARCHAR2(20)
          INDEX BY binary_integer;
      TYPE dep_id IS TABLE OF NUMBER(20)
          INDEX BY binary_integer;
           a dep_name;
           b dep_id;
     BEGIN
      select department_name,department_id bulk collect INTO a,b FROM departments;
--      dbms_output.put_line(a(a.count)||'   '||b(a.count));
        dbms_output.put_line(a(a.first)||'   '||b(a.first));
        dbms_output.put_line(a.first||'   '||a.first);
        dbms_output.put_line(a(a.last)||'   '||b(a.last));

/*
  FOR i IN b.first..b.last
  LOOP
  dbms_output.put_line(i||'  '||a(i)||'---->'||b(i));
END LOOP;
*/
    END;
    / 
 
 -- VARRAY(VARIABLE -SIZED -ARRAY)
 --we can assign the variable size to the array elements
 
 DECLARE 
  TYPE dys_elem IS VARRAY(7) OF VARCHAR2(10);
  v_day dys_elem := dys_elem(null,null,null,null,null,null,null);
BEGIN 
v_day(1):='sunday';
v_day(2):='monday';
v_day(3):='tuesday';
v_day(4):='wednesday'; 
v_day(5):='thursday';
v_day(6):='friday';
v_day(7):='saturday'; 
  dbms_output.put_line(v_day(1));
  dbms_output.put_line(v_day(2));
  dbms_output.put_line(v_day(3));
  dbms_output.put_line(v_day(4));
  dbms_output.put_line(v_day(5));
  dbms_output.put_line(v_day(6));
  dbms_output.put_line(v_day(7));
END;
/
 
--EXECPTION

-- 1>>  Subscript beyond count


 DECLARE 
  TYPE dys_elem IS VARRAY(7) OF VARCHAR2(10);
  v_day dys_elem := dys_elem(null,null); -- can only one value intialize
BEGIN 
v_day(1):='sunday';
--v_day.EXTEND(1);
v_day(2):='monday';

  dbms_output.put_line(v_day(1));
  dbms_output.put_line(v_day(2));
  END;
/



 DECLARE 
  TYPE dys_elem IS VARRAY(7) OF VARCHAR2(10);
  v_day dys_elem := dys_elem(); -- can no value intialize
BEGIN 
v_day.EXTEND(2);
v_day.EXTEND(); --it allow for one value
v_day(1):='sunday';
v_day(2):='monday';

  dbms_output.put_line(v_day(1));
  dbms_output.put_line(v_day(2));
  END;
/

--2>> "Subscript outside of limit"


 DECLARE 
  TYPE dys_elem IS VARRAY(7) OF VARCHAR2(10);
  v_day dys_elem := dys_elem(); -- can no value intialize
BEGIN 
v_day.EXTEND(6);
v_day.EXTEND(); --it allow for one value
v_day(1):='sunday';
v_day(2):='monday';

  dbms_output.put_line(v_day(1));
  dbms_output.put_line(v_day(2));
  END;
/



--3>> "Reference to uninitialized collection"


 DECLARE 
  TYPE dys_elem IS VARRAY(7) OF VARCHAR2(10);
  v_day dys_elem; --  no  intialize the variable
 BEGIN 
v_day.EXTEND(2); --it allow for one value
v_day(1):='sunday';
v_day(2):='monday';

 dbms_output.put_line(v_day(1));
  dbms_output.put_line(v_day(2));
  END;
/
--------------------------------------------------------------------------------

declare
type emp_name is varray(100) of varchar2(20);
nam emp_name :=emp_name(99);
begin
nam.extend(99);
select first_name bulk collect into nam from employees
where rownum <=100
order by employee_id;
dbms_output.put_line(nam.first || nam.count ||nam.last);
for i in nam.first..nam.last
loop
 dbms_output.put_line(i||' employee is  : '||nam(i));
end loop;
end;
/
set serveroutput on;

DECLARE 
  TYPE dys_elem IS VARRAY(7) OF VARCHAR2(10);
  v_day dys_elem:= dys_elem(null,null,null);
 BEGIN 
v_day(1):='sunday';
v_day(2):='monday';
v_day(3):='tuesday';
--v_day(4):='thursday';

 dbms_output.put_line('v_day(1)'||v_day(1));
 dbms_output.put_line('v_day(2)'||v_day(2));
 dbms_output.put_line('v_day() limit is  :'||v_day.limit);
 dbms_output.put_line('v_day() count is  :'||v_day.count);
 dbms_output.put_line('v_day() first is  :'||v_day.first);
 dbms_output.put_line('v_day() first is  :'||v_day.last);
 --v_day.trim(1);
--  dbms_output.put_line('v_day() count  is  :'||v_day.count);
  --v_day.delete;
  --dbms_output.put_line('v_day() count  is  :'||v_day.count);
   v_day.extend();
   v_day(4):='thursday';

  dbms_output.put_line('v_day() count  is  :'||v_day.count);
 dbms_output.put_line('v_day(1)    :'||v_day(1));
 dbms_output.put_line('v_day(2)    :'||v_day(2));
 dbms_output.put_line('v_day(3)    :'||v_day(3));
 dbms_output.put_line('v_day(4)    :'||v_day(4));
  dbms_output.put_line('v_day() prior  is  :'||v_day.prior(1));
  dbms_output.put_line('v_day() next  is  :'||v_day.next(2 ));
  END;
/

---------------------------------------------
DECLARE 
 TYPE matrix_elem_type IS VARRAY(3) OF NUMBER;
 TYPE matrix_type IS VARRAY(3) OF matrix_elem_type;
 lv_matrix1  matrix_type     :=matrix_type(null,null,null);
 lv_matrix2  matrix_type     :=matrix_type(null,null,null);
 lv_matrix3_total matrix_type:=matrix_type(null,null,null);
 lv_matrix_elem matrix_elem_type  := matrix_elem_type(null,null,null);
PROCEDURE print_array(pin_array matrix_type,pin_desc VARCHAR2)
AS
BEGIN
 dbms_output.put_line('printing the '||pin_desc ||'....');
 FOR i IN pin_array.first..pin_array.last
 LOOP
    FOR j IN pin_array(i).first..pin_array(i).last 
    LOOP
      dbms_output.put(pin_array(i)(j)||'  ');
    END LOOP;
     dbms_output.put_line('');
 END LOOP;
 END;
BEGIN
lv_matrix_elem :=matrix_elem_type(1,2,3);
lv_matrix1(1) :=lv_matrix_elem;
lv_matrix_elem :=matrix_elem_type(4,5,6);
lv_matrix1(2) :=lv_matrix_elem;
lv_matrix_elem :=matrix_elem_type(7,8,9);
lv_matrix1(3) :=lv_matrix_elem;

print_array(lv_matrix1,'first array');

lv_matrix_elem :=matrix_elem_type(10,11,12);
lv_matrix2(1) :=lv_matrix_elem;
lv_matrix_elem :=matrix_elem_type(13,14,15);
lv_matrix2(2) :=lv_matrix_elem;
lv_matrix_elem :=matrix_elem_type(16,17,18);
lv_matrix2(3) :=lv_matrix_elem;
--/*
print_array(lv_matrix2,'second array');
--add
FOR i IN lv_matrix1.first..lv_matrix1.last 
LOOP
 FOR j IN lv_matrix1(i).first..lv_matrix1(i).last
 LOOP
 lv_matrix_elem(j):=lv_matrix2(i)(j)-lv_matrix1(i)(j);
 END LOOP;
 lv_matrix3_total(i):=lv_matrix_elem;
 
END LOOP;
print_array(lv_matrix3_total,'total array');
--*/
END;
/
--


TABLE

 DECLARE 
  TYPE nst_elem IS TABLE OF VARCHAR2(10);
  v_day nst_elem := nst_elem(null,null,null);
BEGIN 
 v_day(1):='sunday';
 v_day(2):='monday';
 v_day(3):='tuesday';
v_day.delete(2);
 dbms_output.put_line(v_day(1));
-- dbms_output.put_line(v_day(2));
 dbms_output.put_line(v_day(3));
 dbms_output.put_line(v_day.count);
 dbms_output.put_line(v_day.first);
 dbms_output.put_line(v_day.last);
 dbms_output.put_line(v_day.prior(3));
 dbms_output.put_line(v_day.next(1));
IF v_day.exists(2) THEN
 dbms_output.put_line(v_day(2));
ELSE
 dbms_output.put_line('2 not exists......');
END IF;
END;
/


LIMIT
COUNT
FIRST
LAST
TRIM()
DELETE
DELETE()
EXTEND()
PRIOR()
NEXT()
EXISTS

plsql table/associative array/index

     TYPE arr_val IS TABLE OF VARCHAR2(20)
          INDEX BY binary_integer;--may be varchar2, number   
      a arr_val;
    
--LIMIT
COUNT
FIRST
LAST
--TRIM()
DELETE
DELETE()

--EXTEND()
PRIOR()
NEXT()
EXISTS
--BULK BInD
 TYPE upd_arry IS TABLE OF emp.employee_id%TYPE
           INDEX BY binary_integer;
 up upd_arry;
 BEGIN 
 SELECT employee_id BULK COLLECT INTO up FROM emp;

--varray
 DECLARE 
  TYPE dys_elem IS VARRAY(7) OF VARCHAR2(10);
  v_day dys_elem := dys_elem(null,null,null,null,null,null,null);

--nested array
/

 DECLARE 
  TYPE nst_elem IS TABLE OF VARCHAR2( 10);
  v_day nst_elem := nst_elem(null,null,null);
  --nested  table
 / 

  declare
cursor empname is
select first_name from employees
--fetch first 10 rows only;
where employee_id < 112;
  
type nested_empname is table of employees.first_name%type;
nesempname nested_empname:=nested_empname();

begin
for emp in empname
loop
nesempname.extend;
nesempname(nesempname.last):=emp.first_name;
end loop;

for i in nesempname.first..nesempname.last
loop
dbms_output.put_line(nesempname(i));
end loop;
end;
/
   
 
_________________________________________________________________________________________________________________________
_________________________________________________________________________________________________________________________

--RECORDS::
/
CREATE OR REPLACE PROCEDURE my_rec_p(p_emid in number) 
AS
  TYPE my_emp IS RECORD
  (
   department_id   NUMBER
  ,department_name VARCHAR2(40)
  ,manager_id      NUMBER
  ,location_id     NUMBER
  ,job_id       VARCHAR2(30)
  );
 v_data my_emp;
 BEGIN
   select e.department_id,d.department_name,e.manager_id,d.location_id,e.job_id
   INTO v_data
   FROM employees e ,departments d,locations l
   where e.department_id=d.department_id
   and d.location_id=l.location_id
   and e.employee_id=p_emid;
 dbms_output.put_line(v_data.department_id);
 dbms_output.put_line(v_data.department_name);
 dbms_output.put_line(v_data.manager_id);
 dbms_output.put_line(v_data.location_id);
END;
/
declare
begin
my_rec_p(101);
end;
/



select e.department_id,d.department_name,e.manager_id,d.location_id,e.job_id
    FROM employees e ,departments d,locations l
   where e.department_id=d.department_id
   and d.location_id=l.location_id
   and e.employee_id=103;
   

----------------------------------------------------------------------
-------------------------------------------------------------------------------

CREATE OR REPLACE TYPE emp_typ IS TABLE OF NUMBER;
/


CREATE OR REPLACE TYPE exep_typ IS TABLE OF NUMBER;
/

DECLARE
v_empid emp_typ:=emp_typ(100,103,105,12,170);
v_exep exep_typ:=exep_typ();
BEGIN
   cal_exep_sp(v_empid,v_exep);
   dbms_output.put_line('printing inside the anonymous block');
 FOR i IN v_empid.first..v_empid.count
 LOOP
 IF v_exep(i) IS NOT NULL THEN
   dbms_output.put_line('employee  ' ||v_empid(i)||' having  '||v_exep(i)||  '  years of exep'); 
 ELSE
   dbms_output.put_line(v_empid(i)||' is not a valid employee id');
 END IF;
 END LOOP;
END;
/
 --procedure

CREATE OR REPLACE PROCEDURE cal_exep_sp(p_empid IN emp_typ,p_exep IN OUT exep_typ)
AS
v_exep NUMBER;
BEGIN
 dbms_output.put_line('process inside the proc');
 FOR i IN p_empid.first..p_empid.count
 LOOP
 BEGIN
 select ROUND(MONTHS_BETWEEN(SYSDATE,hire_date)/12)
 INTO v_exep
 FROM employees
 WHERE employee_id =p_empid(i);
 p_exep.EXTEND;
 p_exep(p_exep.LAST):=v_exep;
 EXCEPTION
  WHEN no_data_found THEN
   p_exep.EXTEND;
   p_exep(p_exep.LAST):=NULL;
 END;
 
 END LOOP;
 END;
 /
 
 
 --assignment and equality test
 --both variable having same datatype.
 
DECLARE 
 TYPE x1_typ IS TABLE OF NUMBER;
 TYPE x2_typ IS TABLE OF NUMBER;
 v_a1 x1_typ :=x1_typ(10,20,30,40,50);
 v_b1 x2_typ :=x2_typ ();
 BEGIN
-- v_a1:=v_b1;
 FOR i IN 1..v_a1.COUNT
 LOOP
   dbms_output.put_line(v_a1(i));
 END LOOP;
 END;
 /
 
 
 
DECLARE
 v_a1 x1_typ :=x1_typ(10,20,30,40,50);
 v_b1 x1_typ :=x1_typ ();
 BEGIN
 v_b1:=v_a1;
 
 FOR i IN 1..v_b1.COUNT
 LOOP
   dbms_output.put_line(v_b1(i));
   dbms_output.put_line('____');
   dbms_output.put_line(v_a1(i));
   dbms_output.put_line('____');

 END LOOP;
 IF v_a1=v_b1 THEN
   dbms_output.put_line('contain same data '); 
end if;
 END;
 /
 -- 
CREATE OR REPLACE  TYPE x1_typ IS TABLE OF NUMBER;
/
CREATE OR REPLACE TYPE x2_typ IS TABLE OF NUMBER;
/ 


---bulk collect

DECLARE
  TYPE empdet_typ IS TABLE OF VARCHAR2(50)
  INDEX BY BINARY_INTEGER;
    v_empnm empdet_typ;
BEGIN
FOR i IN 1..107
LOOP
    SELECT first_name INTO v_empnm(i) FROM employees 
     WHERE employee_id=i+99;
 dbms_output.put_line(v_empnm(i));
END LOOP;
END;
/
--using bulk collect
DECLARE
  TYPE empdet_typ IS TABLE OF VARCHAR2(50)
  INDEX BY BINARY_INTEGER;
    v_empnm empdet_typ;
    v_empjb empdet_typ;

BEGIN
    SELECT first_name,job_id BULK COLLECT INTO v_empnm,v_empjb FROM employees;

FOR i IN 1..107
LOOP
 dbms_output.put_line(v_empnm(i)||'____'||v_empjb(i));
END LOOP;
END;
/

-----------------------------------------------------------------------------------

--we use row type in collection
DECLARE
      TYPE arr_val IS TABLE OF employees%rowtype
          INDEX BY binary_integer;
      a arr_val;
BEGIN
    select * bulk collect INTO a FROM employees;
    FOR i IN a.first..a.last
     LOOP
      dbms_output.put_line('('||a(i).employee_id||')  :'||a(i).first_name);
    END LOOP;
    END;
    /





--reffer karthikeyan_task




--varray
declare
type cusname is varray(5) of varchar2(20);
cname cusname:=cusname();
siz number:=100;
begin
--cname:=cusname();
dbms_output.put_line(cname.count);
for i in 1..5
loop
cname.extend;
select first_name into cname(i) from employees
where employee_id =siz;
siz:=siz+1;
end loop;
dbms_output.put_line(cname.count);
for x in 1..cname.count
loop
dbms_output.put_line(cname(x));
end loop;
end;
/
---------------------------------------------------------------------------
--nested array
declare
type cusname is table  of varchar2(20);
cname cusname:=cusname();
siz number; --tt cnt
cnt number:=100;
begin
select count(*) into siz from employees;
for i in 1..siz
loop
cname.extend;
select first_name into cname(i) from employees
where employee_id =cnt;
cnt:=cnt+1;
end loop;
dbms_output.put_line(cname.count);
dbms_output.put_line('- - - - - - - - - - - -'); 

for x in 1..cname.count
loop
dbms_output.put_line('|     '||lpad(rpad(cname(x),9,' '),9,' ')||'     |');
end loop;
dbms_output.put_line('- - - - - - - - - - - -');

end;
/


--associative  array
declare
type cusname is table  of employees.email%type index by employees.first_name%type ;
cname cusname;
siz number; --tt cnt
v_name varchar2(30);
v_email employees.email%type;

cnt number:=100;
begin
select count(*) into siz from employees;
for i in 1..siz
loop
--cname.extend;
select first_name,email into cname(v_name),v_name from employees
where employee_id =cnt;
cnt:=cnt+1;
dbms_output.put_line('the index of ('||cname(v_name)||')  :'||v_name);
end loop;
dbms_output.put_line(cname.count);
dbms_output.put_line(cname.last);
--dbms_output.put_line(cname);

end;
/

set serveroutput on;
for x in cname.first..cname.last
loop
dbms_output.put_line('|     '||lpad(rpad(cname(x),9,' '),9,' ')||'     |');
end loop;
dbms_output.put_line('- - - - - - - - - - - -');
end;
/


select * from employees;





