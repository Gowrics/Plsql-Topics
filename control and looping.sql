
Table CANDIDATED created.


1 row inserted.


1 row inserted.


Error starting at line : 15 in command -
alter table candidates add column meeting_time interval day to seconds
Error report -
ORA-00904: : invalid identifier
00904. 00000 -  "%s: invalid identifier"
*Cause:    
*Action:

Table CANDIDATED dropped.


Error starting at line : 17 in command -
alter table candidates add meeting_time interval day to second
Error report -
ORA-00942: table or view does not exist
00942. 00000 -  "table or view does not exist"
*Cause:    
*Action:

Table CANDIDATED created.


Error starting at line : 17 in command -
insert into candidated values(1,'ravi','manager',interval '12-3' year to month,interval '1 2:12' day to second)
Error at Command Line : 17 Column : 89
Error report -
SQL Error: ORA-01867: the interval is invalid
01867. 00000 -  "the interval is invalid"
*Cause:    The character string you specified is not a valid interval.
*Action:   Please specify a valid interval.

1 row inserted.


1 row inserted.


Table CANDIDATED truncated.


1 row inserted.


1 row inserted.


1 row inserted.


1 row inserted.


1 row inserted.


Table T1 dropped.


Flashback succeeded.


Table T1 dropped.


Flashback succeeded.


Table T1 dropped.


Flashback succeeded.


Error starting at line : 55 in command -
flashback table t1 to before drop
Error report -
ORA-38312: original name is used by an existing object


Rollback complete.


Table T1 dropped.


Flashback succeeded.


Table T1 dropped.


Flashback succeeded.


Error starting at line : 55 in command -
flashback table t1 to before drop
Error report -
ORA-38312: original name is used by an existing object


Table T1 dropped.


Flashback succeeded.


Table T1 dropped.


Flashback succeeded.


Table T1 dropped.


Flashback succeeded.


Table TS1 dropped.


Flashback succeeded.


Table TS1 dropped.


Flashback succeeded.


Table EMP1 dropped.


Error starting at line : 56 in command -
flashback table ts1 to before drop
Error report -
ORA-38312: original name is used by an existing object


Flashback succeeded.


Table EMP1 dropped.


Flashback succeeded.


Table EMP1 dropped.


Error starting at line : 55 in command -
flashback table emp1 to before drop
Error report -
ORA-38305: object not in RECYCLE BIN


Error starting at line : 55 in command -
flashback table emp1 to before drop
Error report -
ORA-38305: object not in RECYCLE BIN


Error starting at line : 63 in command -
where  job_id in()
Error report -
Unknown Command


Error starting at line : 65 in command -
group by job_id
Error report -
Unknown Command


Error starting at line : 65 in command -
group by job_id
Error report -
Unknown Command


Error starting at line : 64 in command -
where  job_id in('AC_MGR',
Error report -
Unknown Command

SP2-0044: For a list of known commands enter HELP
and to leave enter EXIT.

Error starting at line : 74 in command -
create  table t1(ids number)
Error report -
ORA-00955: name is already used by an existing object
00955. 00000 -  "name is already used by an existing object"
*Cause:    
*Action:

Table T1 dropped.


Table T1 created.


1 row inserted.


1 row inserted.


1 row inserted.


Error starting at line : 79 in command -
insert into t1 values()
Error at Command Line : 79 Column : 23
Error report -
SQL Error: ORA-00936: missing expression
00936. 00000 -  "missing expression"
*Cause:    
*Action:

1 row inserted.


1 row inserted.


1 row inserted.


1 row inserted.


Error starting at line : 90 in command -
declare
a number;
procedure squr (x in number) is
begin
x:=x*x;
end;
begin
a:=20;
squr(a);
dbms_output.put_line('sq of the 10 is  :'||a);
end;
Error report -
ORA-06550: line 5, column 1:
PLS-00363: expression 'X' cannot be used as an assignment target
ORA-06550: line 5, column 1:
PL/SQL: Statement ignored
06550. 00000 -  "line %s, column %s:\n%s"
*Cause:    Usually a PL/SQL compilation error.
*Action:
sq of the 10 is  :


PL/SQL procedure successfully completed.

sq of the 10 is  :400


PL/SQL procedure successfully completed.

