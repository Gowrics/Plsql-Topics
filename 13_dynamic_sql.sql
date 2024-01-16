DYNAMIC SQL

Dynamic SQL is a programming methodology for generating and running SQL statements at run time. 
 or when you do not know at compilation time the full text of a SQL statement
 or the number or data types of its input and output variables.

PL/SQL provides two ways to write dynamic SQL:

Native dynamic SQL, a PL/SQL language (that is, native) feature for building and 
running dynamic SQL statements

DBMS_SQL package, an API for building, running, and describing dynamic SQL statements

When you need both the DBMS_SQL package and native dynamic SQL, 
you can switch between them, using the "DBMS_SQL.TO_REFCURSOR Function" and "DBMS_SQL.TO_CURSOR_NUMBER Function".

When You Need Dynamic SQL

In PL/SQL, you need dynamic SQL to run:

    SQL whose text is unknown at compile time

    For example, a SELECT statement that includes an identifier that is unknown at 
	compile time (such as a table name) or a WHERE clause in which the number of 
	subclauses is unknown at compile time.

    SQL that is not supported as static SQL

    That is, any SQL construct not included in "Description of Static SQL".

If you do not need dynamic SQL, use static SQL, which has these advantages:

    Successful compilation verifies that static SQL statements reference valid database
	objects and that the necessary privileges are in place to access those objects.

    Successful compilation creates schema object dependencies.
	
So, how do we use dynamic SQL in Oracle Database?

The two most common methods of using dynamic SQL and PL/SQL in Oracle Database are:

    Execute Immediate statement and
    Open-For, Fetch & Close block.

Execute Immediate statement is used when the query is returning single row data.
 In case the query is returning multi row data then you can take help of Open-For,
 Fetch and close block. We will learn about Execute Immediate and Open-for, 
 fetch and close block in detail in the upcoming tutorials.
 
 Are there any other ways of using Dynamic SQL in Oracle Database?

Apart from above mentioned most commonly used methods, the other ways of using dynamic SQL or PL/SQL are

    With Bulk Fetch
    Secondly with Bulk Execute Immediate
    Along with Bulk FORALL and
    Lastly with Bulk Collect Into statement
	
Specify bind variables in USING clause.
    Specify mode for first parameter.
    Modes of other parameters are correct by default. 	
/

DECLARE
v_a VARCHAR2(300);
BEGIN
--EXECUTE IMMEDIATE 'DROP TABLE new_tb';
EXECUTE IMMEDIATE 'CREATE TABLE new_tb(id number,name varchar2(30))';
--EXECUTE IMMEDIATE 'INSERT INTO new_tb values (1,'a')';
END;
/

begin
INSERT INTO new_tb values (2,'b');
INSERT INTO new_tb values (3,'c');
INSERT INTO new_tb values (4,'d');
INSERT INTO new_tb values (5,'e');
INSERT INTO new_tb values (6,'f');
INSERT INTO new_tb values (7,'g');
end;
/
select * from new_tb;

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE new_tb';
END;
/

Declare
    Sql_Smt Varchar2(150);
Begin
    Sql_Smt := 'UPDATE new_tb SET name = :new_name 
    WHERE name = :old_name ';
    Execute Immediate Sql_Smt Using 'e','k';   
End;
/


DECLARE
v_a VARCHAR2(300);
BEGIN
v_a := 'DECLARE
        v_b varchar2(10);
		BEGIN
		SELECT USER INTO v_b from dual;
		dbms_output.put_line(v_b);
		END;';
		EXECUTE IMMEDIATE v_a;
END;
/

--

--example of bulk collect into with execute immediate.
DECLARE
    TYPE ty_name IS TABLE OF VARCHAR2 (60);
    tname ty_name;
    v_a VARCHAR2(150);
BEGIN
    v_a := 'SELECT first_name FROM employees';
    EXECUTE IMMEDIATE v_a BULK COLLECT INTO tname;
    FOR idx IN 1..tname.COUNT
        LOOP
            DBMS_OUTPUT.PUT_LINE(idx||' - '||tname(idx));
        END LOOP;
END;
/
