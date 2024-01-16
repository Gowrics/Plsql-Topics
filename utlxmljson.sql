s


<LINK XML>
(https://oracle-base.com/articles/misc/sqlxml-sqlx-generating-xml-content-using-sql#sqlxml_functions)



 XML GENERATION UING SQL
------------------------------------------------------------------------------------------------		 
		 Oracle has built-in functions to convert relational data into XML format easily. These functions comes under the umbrella of SQL/XML, a specification that supports 
         the mapping and manipulation of XML from SQL.
		 
		 >SQL/XML is an emerging part of the ANSI and ISO SQL standard
         >describing the ways the Database Language SQL can be used in conjunction with XML.

FUNCTIONS:
         > SQL/XML Functions
         > XMLELEMENT
         > XMLATTRIBUTES
         > XMLFOREST
         > XMLAGG
         > XMLROOT
         > XMLCDATA

XMLELEMENT:
        > The XMLELEMENT function is the basic unit for turning column data into XML fragments. 
		
		SELECT XMLELEMENT("name", first_name) AS employee
         FROM   employees
         WHERE  employee_id = 100;
			
		 SELECT XMLElement( "DEPARTMENT"
                 , department_name
                 )
         FROM departments
         WHERE department_id IN (10, 20);

XMLATTRIBUTES:
        > The XMLATRIBUTES function converts column data into attributes of the parent element. 
	    > The function call should contain one or more columns in a comma separated list.

       SELECT XMLElement("DEPARTMENTS", XMLAttributes( department_id deptid)
                 , department_name
                 )
         FROM departments
         WHERE department_id IN (10);
``````````````````````````````````````````````````````````````````````````````
SELECT XMLELEMENT("employee",
                   XMLATTRIBUTES(e.employee_id AS "emp_number",e.first_name AS "name")
                   ,e.salary ) AS employee
FROM   employees e
WHERE  e.employee_id = 120;

         
  
--my ex

select XMLELEMENT("EMP_ID",e.employee_id),
       XMLELEMENT("DEPT_NAME",d.department_name),
       XMLELEMENT("EMP_SAL",e.salary)
from employees e,departments d
where e.department_id=d.department_id
and e.department_id in (30);         
``````````````````````````````````````````````````````````````````````````````




	
  FOR MORE THAN ONE ELEMENT
	   SELECT XMLElement("DEPARTMENT", department_id)
            , XMLElement("DEPARTMENT", department_name)
          FROM departments
          WHERE department_id IN (10, 20);
		  
		  But it returns value in two different columns, so we go for XMLFOREST

XMLFOREST:
          > Using XMLELEMENT to deal with lots of columns is rather clumsy. 
		  > Like XMLATTRIBUTES, the XMLFOREST function allows you to process
             multiple columns at once.
		  ````````````````````````````````````````````````````
   select XMLELEMENT("employees",  
                      XMLFOREST(employee_id empno
                               ,first_name name
                               ,job_id job)
                     ) empdtls
  from employees
  where employee_id =113;
          ``````````````````````````````````````````````````````
          
		SELECT XMLForest(department_id as "ID"
                , department_name as "NAME"
                )
          FROM departments
          WHERE department_id IN (10, 20);                                       --REDGATE SOFTWARE LTD
		  


SELECT XMLForest(department_id as "ID"
                ,department_name as "NAME"    
                ,location_id as "LOC_ID"
                )
          FROM departments
          WHERE department_id IN (10, 20);   
\


SELECT XMLELEMENT("employee",
         XMLELEMENT("works_number", e.employee_id),
         XMLELEMENT("name", e.first_name)
       ) AS employee
FROM   employees e
WHERE  e.employee_id = 129;



XMLAGG:




           * It is used for the aggreate function like group by and order by clause in the xml document.
		   * any argument return null value dropped from result.
			
       
`````````````````````````````````````````````````````````````````````````````````````````/

select XMLAGG(
              XMLELEMENT(emp_details,
                   XMLFOREST(employee_id id
                            ,first_name name
                            ,department_id deptid
                            ,salary salary
                            )
                          )
                )emps
from employees
where department_id =20;



`````````````````````````````````````````````````````````````````````````````````````````
       
       
          SELECT XMLAgg(XMLElement("DEPARTMENT"
                        , XMLAttributes( department_id as "ID"
                                       )
                        , department_name
                        )
                        --order by department_name desc
                        ) xml_op
             FROM departments;
             WHERE department_id IN (10, 20);
			 
XMLROOT:
        > The XMLROOT function allows us to place an XML declaration tag at the start of our XML document. 
		> In newer database versions, this function is either deprecated, or removed entirely. 
		> If you need and XML declaration, you should add it manually to the document.
		
		
SELECT XMLROOT(
         XMLELEMENT("employees",
           XMLAGG(
             XMLELEMENT("employee",
               XMLFOREST(
                 e.employee_id AS "works_number",
                 e.first_name AS "name")
             )
           )
         )
       ) AS emp
FROM   employees e
WHERE  e.department_id = 10;

		
	
    
    
    	select xmlroot(xmltype('<poid>123456</poid>'),
                     version'1.0',standalone yes) as "XMLROOT" from dual;
		
    
XMLCDATA:
        > The XMLCDATA function surrounds column data with a CDATA tag.
		
       SELECT XMLELEMENT("employees",
         XMLAGG(
           XMLELEMENT("employee",
             XMLFOREST(employee_id AS "works_number",
               XMLCDATA(first_name) AS "name")
           )
         )
       ) AS employees
FROM   employees
WHERE  department_id = 50;
``````````````````````````````````````````````````````````````````````````````````````````````````````````

SELECT XMLElement("Emp", 
                  XMLAttributes(e.first_name ||' '||e.last_name AS "fullname" ),
                  XMLColAttVal(e.hire_date, e.department_id AS "department"))
  AS "RESULT" 
  FROM employees e
  WHERE e.department_id = 30;





--------------------------------------------------------------------------------------------------------------	

		  select dbms_xmlgen.getxml('select employee_id, first_name,
          last_name, phone_number from employees where rownum < 4') xml from dual;  --just for reference
		  
		  
		  SELECT dbms_xmlgen.getXml('SELECT employee_id"EMP_NO"
                                      , first_name "NAME"
                                      , department_id "DEPT_NO"   
           FROM employees
           WHERE department_id = 50') XML FROM dual;	                          --just for reference
------------------------------------------------------------------------------------------------------------
		 
		
create sequence xml_seq increment by 1;

create or replace procedure xml_gen_sp 
as
v_seq number;
v_output xmltype;
begin
select xml_seq.nextval into v_seq from dual;
v_output := dbms_xmlgen.getxmltype('select * from departments');
insert into xml_tb(id, xml_data) values(v_seq, v_output); 
end;
/

drop table xml_tb;

create table xml_tb of xmltype;

select * from xml_tb;


SELECT extractvalue(value(e),',/Department/@department_no') as deptno,
       extractvalue(value(e),'/Department/@department_name') as deptno,
       extractvalue(value(e),'/Department/@manager_id') as deptno,
	   extractvalue(value(e),'/Department/@location_id') as deptno
from xml_tb e; 
       
---------------------------------------------------------------------------------

create sequence xml_seq increment by 1;


CREATE TABLE xml_tb (
  id        NUMBER ,
  xml_data  XMLTYPE
);
-----------------------------------------
create or replace procedure xml_gen_sp 
as
v_seq number;
 l_xmltype XMLTYPE;
begin
 SELECT XMLELEMENT("employees",
           XMLAGG(
             XMLELEMENT("employee",
               XMLFOREST(
                 e.department_id AS "department_id",
                 e.department_name AS "department_name",
                 e.manager_id AS "manager_id",
                 e.location_id AS "location_id"
               )
             )
           ) 
         )
  INTO   l_xmltype
  FROM  departments e;
  
select xml_seq.nextval into v_seq from dual;

insert into xml_tb(id, xml_data) values(v_seq, l_xmltype); 
commit;
end;
/
----------------------------------------------------------------
SELECT xt.*
FROM   xml_tb x,
       XMLTABLE('/employees/employee'
         PASSING x.xml_data         COLUMNS 
           department_id     VARCHAR2(20)  PATH 'department_id',
           department_name     VARCHAR2(20) PATH 'department_name',
           manager_id       VARCHAR2(20)  PATH 'manager_id',
           location_id  VARCHAR2(20) PATH 'location_id'
         ) xt;








--XML---

Xtensionable Markable Language.

xml format:
 
--DBMS_XMLGEN.GETXML
SELECT DBMS_XMLGEN.GETXML('SELECT * FROM employees WHERE employee_id=109') from dual;

xml EXTRACT TO table format:

CREATE TABLE t_xml (xml_col XMLTYPE);
DECLARE
  qryctx DBMS_XMLGEN.CTXHANDLE;
  v_result XMLTYPE;
BEGIN
  qryctx := DBMS_XMLGEN.NEWCONTEXT('SELECT employee_id,first_name,last_name,hire_date,salary FROM employees WHERE department_id = 30');
  v_result := DBMS_XMLGEN.GETXMLTYPE(qryctx);
  DBMS_XMLGEN.CLOSECONTEXT(qryctx);
  INSERT INTO t_xml VALUES(v_result);
  COMMIT;  
END;
/ 


SELECT * FROM t_xml;

-- to extract value of rows 

SELECT EXTRACTVALUE(VALUE(e1),'/ROW/EMPLOYEE_ID') AS employee_id,
       EXTRACTVALUE(VALUE(e1),'/ROW/FIRST_NAME')AS first_name,
	   EXTRACTVALUE(VALUE(e1),'/ROW/LAST_NAME') AS last_name,
	   EXTRACTVALUE(VALUE(e1),'/ROW/HIRE_DATE') AS hire_date,
	   EXTRACTVALUE(VALUE(e1),'/ROW/SALARY') AS salary
  FROM t_xml,
TABLE(XMLSEQUENCE(EXTRACT(xml_col,'/ROWSET/ROW'))) e1; 



CREATE TYPE emp_row AS OBJECT (
  EMPNO     NUMBER(4),
  ENAME     VARCHAR2(10),
  JOB       VARCHAR2(9),
  MGR       NUMBER(4),
  HIREDATE  DATE,
  SAL       NUMBER(7,2),
  COMM      NUMBER(7,2)
);
/