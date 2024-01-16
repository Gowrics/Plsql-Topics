?	Create the 'employe' table

CREATE TABLE employe (
employee_id NUMBER PRIMARY KEY,
First_name VARCHAR2(50),
Last_name VARCHAR2(50),
Last_modified TIMESTAMP
);

select * from employe;
?	Create a trigger to update the 'last_modified' timestamp

CREATE OR REPLACE TRIGGER update_last_modify
BEFORE UPDATE ON employe
FOR EACH ROW
BEGIN
:NEW.last_modified := SYSTIMESTAMP;
END;
/
?	Insert a sample record
INSERT INTO employe (employee_id,first_name,last_name,last_modified) VALUES (5, 'Mohn','Hoe',sysdate);
?	Verify the initial timestamp
SELECT * FROM employe;

?	Update the record
UPDATE employe SET first_name = 'Hoae' WHERE employee_id = 1;

?	Verify the updated timestamp
SELECT * FROM employe;



?	Create the 'ordrs' table
CREATE TABLE ordrs (
Order_id NUMBER PRIMARY KEY,
Order_date TIMESTAMP,
Order_amount NUMBER
);



?	Create a trigger to prevent updates during specific hours

CREATE OR REPLACE TRIGGER prevent_updates
BEFORE UPDATE OF order_amount ON ordrs
FOR EACH ROW
DECLARE
Current_hour NUMBER;
BEGIN
--	Get the current hour
    SELECT TO_NUMBER(TO_CHAR(SYSTIMESTAMP, 'HH24')) INTO current_hour FROM DUAL;

--	Check if it's outside of business hours (9 AM to 5 PM)
    IF current_hour< 9 OR current_hour>= 17 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Updates are not allowed during non-business hours.');
    END IF;
END;
/
?	Insert a sample order
INSERT INTO ordrs (order_id, order_date, order_amount) VALUES (2, SYSTIMESTAMP, 1023);

?	Update the order amount during business hours
UPDATE ordrs SET order_amount = 1500 WHERE order_id = 1;

?	Update the order amount during non-business hours
UPDATE ordrs SET order_amount = 2000 WHERE order_id = 1;



?	Create the 'employes' table
CREATE TABLE employes (
employee_id NUMBER PRIMARY KEY,
First_name VARCHAR2(50),
Last_name VARCHAR2(50)
);

?	Create the 'employe_history' table for maintaining the log
drop table employe_history;
CREATE TABLE employe_history (
employee_id NUMBER,
Deleted_date TIMESTAMP,
Deleted_by VARCHAR2(50)
);

?	Create a trigger to maintain a transaction history log
CREATE OR REPLACE TRIGGER maintain_history_log
BEFORE DELETE ON employes
FOR EACH ROW
DECLARE
V_deleted_by VARCHAR2(50);
BEGIN
--	Get the current user
    SELECT USER INTO v_deleted_by FROM DUAL;
--	Insert a record into the employe_history table
    INSERT INTO employe_history (employee_id, deleted_date, deleted_by)
    VALUES (:OLD.employee_id, SYSTIMESTAMP, v_deleted_by);
END;
/

?	Insert sample employe records
INSERT INTO employes (employee_id, first_name, last_name) VALUES (1, 'John', 'Doe');
INSERT INTO employes (employee_id, first_name, last_name) VALUES (2, 'Jane', 'Smith');
?	Delete an employe
DELETE FROM employes WHERE employee_id =2;
?	View the employe_history table to see the log
SELECT * FROM employe_history;


?	Create the 'departments' table
CREATE TABLE departmnts (
Departmnt_id NUMBER PRIMARY KEY,
Departmnt_name VARCHAR2(50)
);

?	Create the 'employes' table with a foreign key reference
drop table employes; 
CREATE TABLE employes (
employee_id NUMBER PRIMARY KEY,
First_name VARCHAR2(50),
Last_name VARCHAR2(50),
Department_id NUMBER,
    CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES departments (department_id)
);

?	Create a trigger to enforce referential integrity
CREATE OR REPLACE TRIGGER prevent_parent_deletion
BEFORE DELETE ON departments
FOR EACH ROW
DECLARE
V_count NUMBER;
BEGIN
--	Check if there are any associated child records
    SELECT COUNT(*) INTO v_count FROM employes WHERE department_id = :OLD.department_id;

--	If child records exist, raise an error
    IF v_count> 0 THEN``
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete department with associated employes.');
    END IF;
END;
/
?	Insert sample department and employe records
INSERT INTO departmnts (departmnt_id, departmnt_name) VALUES (1, 'Sales');
INSERT INTO employes (employee_id, first_name, last_name, department_id) VALUES (1, 'John', 'Doe', 1);
select * from employes;
departmnts;

?	Try to delete the department with associated employes
DELETE FROM departments WHERE department_id = 1; -- This will raise an error

?	Delete the employe first
DELETE FROM employes WHERE employee_id = 1;

?	Now, delete the department
DELETE FROM departments WHERE department_id = 1; -- This will work

-----------------------------------
?	Create the 'products' table
CREATE TABLE products (
Product_id NUMBER PRIMARY KEY,
Product_name VARCHAR2(50)
);
?	Create a trigger to check for duplicate values
CREATE OR REPLACE TRIGGER prevent_duplicates
BEFORE INSERT ON products
FOR EACH ROW
DECLARE
V_count NUMBER;
BEGIN
?	Check if the new product_name already exists
    SELECT COUNT(*) INTO v_count FROM products WHERE product_name = :NEW.product_name;
?	If duplicate value found, raise an error
    IF v_count> 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Product name already exists.');
    END IF;
END;
/

?	Insert a product
INSERT INTO products (product_id, product_name) VALUES (1, 'Widget');
?	Try to insert a product with a duplicate name
INSERT INTO products (product_id, product_name) VALUES (2, 'Widget'); -- This will raise an error


?	Create the ordrs table
drop table ordrs;
CREATE TABLE ordrs (
Order_id NUMBER PRIMARY KEY,
Customer_id NUMBER,
Order_amount NUMBER
);

?	Create a trigger to restrict total order amount
CREATE OR REPLACE TRIGGER check_order_amount
BEFORE INSERT ON ordrs
FOR EACH ROW
DECLARE
Total_amount NUMBER;
Max_threshold NUMBER := 10000; -- Change this to your desired threshold
BEGIN
--	Calculate the current total order amount for the customer
    SELECT NVL(SUM(order_amount), 0) INTO total_amount
    FROM ordrs
    WHERE customer_id= :NEW.customer_id;

--	Check if inserting the new row will exceed the threshold
    IF total_amount+ :NEW.order_amount>max_threshold THEN
        RAISE_APPLICATION_ERROR(-20001, 'Total order amount exceeds the threshold.');
    END IF;
END;
/
-- Inserting rows that don't exceed the threshold
INSERT INTO ordrs (order_id, customer_id, order_amount) VALUES (1, 101, 5000);
INSERT INTO ordrs (order_id, customer_id, order_amount) VALUES (2, 101, 3000);
INSERT INTO ordrs (order_id, customer_id, order_amount) VALUES (3, 102, 8000);
INSERT INTO ordrs (order_id, customer_id, order_amount) VALUES (4, 101, 2000);
INSERT INTO ordrs (order_id, customer_id, order_amount) VALUES (5, 102, 2001);
INSERT INTO ordrs (order_id, customer_id, order_amount) VALUES (6, 103, 1000);

-- Attempting to insert a row that would exceed the threshold
-- This should raise an error and prevent the insertion
BEGIN
    INSERT INTO ordrs (order_id, customer_id, order_amount) VALUES (4, 102, 5000);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/



?	Create the employes table
CREATE TABLE employes (
employee_id NUMBER PRIMARY KEY,
employe_nameVARCHAR2(100),
Salary NUMBER
);

?	Create the salary_audit table to store changes
CREATE TABLE salary_audit (
Audit_id NUMBER PRIMARY KEY,
employee_id NUMBER,
Old_salary NUMBER,
New_salary NUMBER,
Change_date TIMESTAMP
);

?	Create a sequence for generating unique audit Ids
CREATE SEQUENCE seq_salary_audit START WITH 1 INCREMENT BY 1;

?	Create a trigger to capture changes in salary
CREATE OR REPLACE TRIGGER salary_change_audit
AFTER UPDATE ON employes
FOR EACH ROW
WHEN (NEW.salary<>OLD.salary) – Only capture changes in the salary column
DECLARE
V_audit_id NUMBER;
BEGIN
--	Generate a unique audit ID
    SELECT seq_salary_audit.NEXTVAL INTO v_audit_id FROM DUAL;

--	Insert the change details into the audit table
    INSERT INTO salary_audit (audit_id, employee_id, old_salary, new_salary, change_date)
    VALUES (v_audit_id, :OLD.employee_id, :OLD.salary, :NEW.salary, SYSTIMESTAMP);
END;
/



?	Inserting a sample employe record
INSERT INTO employes (employee_id, employe_name, salary)
VALUES (1, 'John Doe', 50000);

?	Updating the salary of the employe
UPDATE employes SET salary = 60000 WHERE employee_id = 1;







-- Create Employee table
drop table employee;
CREATE TABLE Employee (
Emp_id NUMBER PRIMARY KEY,
Emp_name VARCHAR2(100),
Emp_salary NUMBER
);
? Create Audit_Log table
CREATE TABLE Audit_Log (
Log_id NUMBER PRIMARY KEY,
Table_name VARCHAR2(100),
Activity_type VARCHAR2(20),
Activity_date TIMESTAMP,
User_id VARCHAR2(50)
);
CREATE SEQUENCE Audit_Log_Seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER Employee_Audit_Trigger
AFTER INSERT OR UPDATE OR DELETE ON Employee
FOR EACH ROW
DECLARE
V_activity_type VARCHAR2(20);
BEGIN
    IF INSERTING THEN
V_activity_type := 'INSERT';
    ELSIF UPDATING THEN
V_activity_type := 'UPDATE';
    ELSIF DELETING THEN
V_activity_type := 'DELETE';
    END IF;
    INSERT INTO Audit_Log (log_id, table_name, activity_type, activity_date, user_id)
    VALUES (Audit_Log_Seq.NEXTVAL, 'Employee', v_activity_type, SYSTIMESTAMP, USER);
END;
/
? Insert a new employee
INSERT INTO Employee (emp_id, emp_name, emp_salary)
VALUES (1, 'John Doe', 50000);
? Update an employee’s salary
UPDATE Employee SET emp_salary = 55000 WHERE emp_id = 1;
? Delete an employee
DELETE FROM Employee WHERE emp_id = 1;
SELECT * FROM Audit_Log;






