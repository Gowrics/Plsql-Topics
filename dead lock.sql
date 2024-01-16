select * FROM emp1 where employee_id in(114,115);



DEADLOCKS:
************
A deadlock occurs when two or more sessions are waiting for data locked by each other,
resulting in all the sessions being blocked. Oracle automatically detects and resolves deadlocks
by rolling back the statement associated with the transaction that detects the deadlock. 
Typically, deadlocks are caused by poorly implemented locking in application code. 
This article shows the steps necessary to identify the offending application code when a deadlock is detected.

----------->---Error: ORA-00060: deadlock detected while waiting for resource

Deadlock Illustration
 
 
Lets see a quick example of how deadlock occurs

 

Step 1

Session #1 performs an update of a row (employee #151) and acquires a lock on that row

SQL> UPDATE employee
          SET first_name = 'David'
          WHERE employee_id = 151;
1 row updated.

 

Step 2 

Session #2 performs an update of a row (employee #39) and acquires a lock on that row

SQL> UPDATE employee
          SET first_name = 'Greg'
          WHERE employee_id = 39;
1 row updated.

 

Step 3

Session #1 performs an update of a row (employee #39) and is now waiting since a lock has been acquired on the same row 
which has not been released yet as session #2 transaction is still active

UPDATE employee<br/>          SET first_name = 'Mark'<br/>          WHERE employee_id = 39;<br/>
 

Step 4

Session #2 performs an update of a row (employee #151) and is now waiting since a lock has been acquired on the same row
 which has not been released yet as session #1 transaction is still active.  

SQL&gt; UPDATE employee<br/>          SET first_name = 'John'<br/>          WHERE employee_id = 151;<br/>

At this stage both sessions (session #1 and session #2) are blocked  and waiting to each other’s locked resources - thats exactly what deadlock is.

-----------------------------------------------------------------------------------------------------------------------------------------------------
