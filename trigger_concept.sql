create table simple(name varchar2(20));

drop table simple;
create table simple_his(name varchar2(200));

create or replace trigger sim_trg
before insert or update or delete
on simple
declare
det varchar2(200);
begin
if inserting then
det:=user||'is inserting in the table at '||to_char(sysdate,'dd-mm-yy hh:mi');
insert into simple_his values(det);
end if;

if updating then
det:=user||'is  updating  the table at '||to_char(sysdate,'dd-mm-yy hh:mi');
insert into simple_his values(det);
end if;

if deleting then
det:=user||'is  deleting  the table at '||to_char(sysdate,'dd-mm-yy hh:mi');
insert into simple_his values(det);
end if;
end;
/


insert into simple values('pathi');

select * from simple;
select * from simple_his;

declare
v varchar2(100);
begin 
v:=user||'is inserting in the table at '||to_char(sysdate,'dd-mm-yy hh:mi');
insert into simple_his1 values(v);
end;
/

update simple
set name='GOWRI'
where name = 'gowri';

delete simple
where name ='GOWRI';
-------------------------------------------------------------------------------

select * from icici_trans_tb;
CREATE TABLE icici_trans_tb (ref_id number,ref_name varchar2(300));      --tb created
CREATE TABLE icici_trans_his (ref_id number,ref_details varchar2(200));  --trg tb created

select * from icici_trans_his;
drop table icici_trans_his;

----------------------trg create row level trg------------
CREATE OR REPLACE TRIGGER time_restr_trg
BEFORE INSERT OR UPDATE OR DELETE ON icici_trans_tb
for each row
DECLARE
v varchar2(200);
BEGIN
  if to_char(sysdate,'d') in(1,7) then --or to_char(sysdate,'hh24:mi') not between '09:00' and '21:00' then
       RAISE_APPLICATION_ERROR(-20004,'transaction not possible in this time');
  else 
     v:=user||'is inserting in the table at '||to_char(sysdate,'dd-mm-yy hh:mi');
  end if;
  if inserting then
  insert into icici_trans_his(ref_id,ref_details) values(:new.ref_id,v);
  end if;
  if updating then
  v:=user||'is updating in the table at '||to_char(sysdate,'dd-mm-yy hh:mi');
  insert into icici_trans_his(ref_id,ref_details) values(:new.ref_id,v);
  end if;
  if deleting then
  v:=user||'is deleting in the table at '||to_char(sysdate,'dd-mm-yy hh:mi');
  insert into icici_trans_his(ref_id,ref_details) values(:new.ref_id,v);
  end if;
  
END time_restr_trg;
/
------------trg----------------------------------

insert into icici_trans_tb values(103,'vasantha4');
---aftr insert chk the tbls--------------------
select * from icici_trans_tb;
select * from icici_trans_his;


update icici_trans_tb 
set ref_name='Dhanya4th'
where ref_id =102;

select to_char(sysdate,'hh24:mi') from dual;