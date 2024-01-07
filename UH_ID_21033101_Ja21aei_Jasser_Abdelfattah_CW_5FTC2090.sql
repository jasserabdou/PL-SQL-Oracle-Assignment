-- Question 1
CREATE VIEW empjob_v AS
    SELECT
        *
    FROM
        jobs;

-- View EMPJOB_V created.
-- 19 rows selected.
-- JOB_ID       JOB_TITLE                               MIN_SALARY      MAX_SALARY                           
-- ----------- ----------------------------------      ------------    ------------
-- AD_PRES      President                                     20080           40000
-- AD_VP        Administration Vice President                 15000           30000  
-- AD_ASST      Administration Assistant                       3000            6000
-- FI_MGR       Finance Manager                                8200           16000
-- FI_ACCOUNT   Accountant                                     4200            9000


-- Question 2
CREATE VIEW empdate_v AS
    SELECT
        employee_id,
        last_name,
        hire_date AS starting_on,
        job_id
    FROM
        employees
    ORDER BY
        hire_date;

-- View EMPDATE_V created.
-- 107 rows selected. 
-- EMPLOYEE_ID   LAST_NAME   STARTING_ON   JOB_ID
-- ------------ -----------  ----------- ------------
-- 102          Garcia        13-JAN-11   AD_VP
-- 203          Jacobs        07-JUN-12   HR_REP
-- 204          Brown         07-JUN-12   PR_REP
-- 205          Higgins       07-JUN-12   AC_MGR
-- 206          Gietz         07-JUN-12   AC_ACCOUNT


-- Question 3
CREATE VIEW deptnohead_v AS
    SELECT
        *
    FROM
        departments
    WHERE
        manager_id IS NULL;

-- View DEPTNOHEAD_V created.
-- 16 rows selected. 
-- DEPARTMENT_ID   DEPARTMENT_NAME   MANAGER_ID    LOCATION_ID
-- --------------  ----------------  ------------  -------------
--           120    Treasury		         (null)         1700
--           130	Corporate Tax		     (null)         1700
--           140	Control And Credit		 (null)         1700
--           150	Shareholder Services     (null)         1700
--           160	Benefits		         (null)         1700


-- Question 4
CREATE VIEW deptcount_v AS
    SELECT
        d.department_id,
        d.department_name,
        COUNT(e.employee_id) AS num_of_employees
    FROM
        departments d
        LEFT JOIN employees   e ON d.department_id = e.department_id
    GROUP BY
        d.department_id,
        d.department_name
    ORDER BY
        d.department_name;

-- View DEPTCOUNT_V created.
-- 27 rows selected.
-- DEPARTMENT_ID   DEPARTMENT_NAME  NUM_OF_EMPLOYEES
-- --------------  ---------------- -----------------
--            110	Accounting	                   2
--             10	Administration	               1
--            160	Benefits	                   0
--            180	Construction	               0
--            190	Contracting	                   0


-- Question 5 
CREATE VIEW empread_v AS
    SELECT
        *
    FROM
        employees
WITH READ ONLY;
-- View EMPREAD_V created.
-- 107 rows selected.

insert into empread_v values
    ( 1000, 'John', 'cena', 'onehey', '1.650.555.0164', '13 - jan - 18', 'sh_clerk', 8000, null, 124, 50 ) 
-- Error at Command Line : 1 Column : 1
-- Error report -
-- SQL Error: ORA-42399: cannot perform a DML operation on a read-only view
-- 42399.0000 - "cannot perform a DML operation on a read-only view"    

--  EMPLOYEE_ID   FIRST_NAME   LAST_NAME    EMAIL       PHONE_NUMBER    HIRE_DATE    JOB_ID     SALARY    COMMISSION_PCT   MANAGER_ID    DEPARTMENT_ID
--  ------------  ------------ -----------  --------    --------------  ----------   ---------  --------  ---------------  ------------  ---------------
--          199	  Douglas      Grant	    DGRANT	    1.650.555.0164	13-JAN-18	 SH_CLERK	    2600		   (null)           124	             50
--          200	  Jennifer     Whalen	    JWHALEN	    1.515.555.0165	17-SEP-13	 AD_ASST	    4400		   (null)           101	             10
--          201	  Michael      Martinez	    MMARTINE	1.515.555.0166	17-FEB-14	 MK_MAN	       13000		   (null)           100	             20
--          202	  Pat          Davis	    PDAVIS	    1.603.555.0167	17-AUG-15	 MK_REP	        6000		   (null)           201	             20
--          203	  Susan	       Jacobs	    SJACOBS	    1.515.555.0168	07-JUN-12	 HR_REP	        6500		   (null)           101	             40


-- Question 6
SET SERVEROUTPUT ON;

DECLARE
    CURSOR emp_cursor IS
    SELECT
        last_name,
        salary,
        hire_date
    FROM
        employees
    WHERE
        EXTRACT(YEAR FROM hire_date) > 2015;

BEGIN
    FOR emp_rec IN emp_cursor LOOP
        dbms_output.put_line('Last Name: '
                             || emp_rec.last_name
                             || ', Salary: '
                             || emp_rec.salary
                             || ', Hire Date: '
                             || to_char(emp_rec.hire_date, 'DD-MON-YYYY'));
    END LOOP;
END;

-- Last Name: McLeod, Salary: 3200, Hire Date: 01-JUL-2016
-- Last Name: Jones, Salary: 2800, Hire Date: 17-MAR-2017
-- Last Name: Walsh, Salary: 3100, Hire Date: 24-APR-2016
-- Last Name: Feeney, Salary: 3000, Hire Date: 23-MAY-2016
-- Last Name: OConnell, Salary: 2600, Hire Date: 21-JUN-2017
-- PL/SQL procedure successfully completed.


-- Question 7
SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION increasesalary (
    original_salary      NUMBER,
    percentage_increment NUMBER
) RETURN NUMBER IS
    new_salary NUMBER;
BEGIN
    new_salary := original_salary * ( 1 + percentage_increment );
    RETURN new_salary;
END increasesalary;

-- Function INCREASESALARY compiled


-- Question 8
SELECT
    increasesalary(2000, 0.20) AS new_salary
FROM
    dual;

-- Function INCREASESALARY compiled
--  NEW_SALARY
--  ----------
--        2400


-- Question 9
SELECT
    last_name,
    hire_date,
    salary AS oldsalary,
    increasesalary(salary, 0.20) AS newsalary
FROM
    employees
WHERE
    hire_date < TO_DATE('2017-01-01', 'YYYY-MM-DD')
    AND salary < 3000;

-- LAST_NAME                 HIRE_DATE  OLDSALARY  NEWSALARY
-- ------------------------- --------- ---------- ----------
-- Baida                     24-DEC-15       2900       3480
-- Tobias                    24-JUL-15       2800       3360
-- Himuro                    15-NOV-16       2600       3120
-- Mikkilineni               28-SEP-16       2700       3240
-- Atkinson                  30-OCT-15       2800       3360
-- Marlow                    16-FEB-15       2500       3000
-- Rogers                    26-AUG-16       2900       3480
-- Seo                       12-FEB-16       2700       3240
-- Patel                     06-APR-16       2500       3000
-- Matos                     15-MAR-16       2600       3120
-- Vargas                    09-JUL-16       2500       3000

-- LAST_NAME                 HIRE_DATE  OLDSALARY  NEWSALARY
-- ------------------------- --------- ---------- ----------
-- Venzl                     11-JUL-16       2900       3480

-- 12 rows selected. 


-- Question 10 
CREATE OR REPLACE FUNCTION getdepartmentsnum RETURN NUMBER IS
    total_departments NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO total_departments
    FROM
        departments;

    RETURN total_departments;
END getdepartmentsnum;

-- Function GETDEPARTMENTSNUM compiled


-- Question 11
DECLARE
    num_departments NUMBER;
BEGIN
    num_departments := getdepartmentsnum();
    dbms_output.put_line('Number of departments: ' || num_departments);
END;

-- Function GETDEPARTMENTSNUM compiled
-- Number of departments: 27
-- PL/SQL procedure successfully completed.


-- Question 12 
CREATE OR REPLACE TRIGGER displaysalarychange BEFORE
    UPDATE OF salary ON employees
    FOR EACH ROW
DECLARE
    salary_difference NUMBER;
BEGIN
    salary_difference := :new.salary - :old.salary;
    dbms_output.put_line('Old Salary: ' || :old.salary);
    dbms_output.put_line('New Salary: ' || :new.salary);
    dbms_output.put_line('Salary Difference: ' || salary_difference);
END;
-- Trigger DISPLAYSALARYCHANGE compiled

SET SERVEROUTPUT ON;

UPDATE employees
SET
    salary = 8000
WHERE
    employee_id = 123;
-- Old Salary: 7000
-- New Salary: 8000
-- Salary Difference: 1000


-- Question 13 
CREATE OR REPLACE TRIGGER stopsoaringsalary BEFORE
    UPDATE OF salary ON employees
    FOR EACH ROW
DECLARE
    max_increase NUMBER := 0.20;
BEGIN
    IF ( :new.salary - :old.salary ) > max_increase * :old.salary THEN
        :new.salary := :old.salary * ( 1 + max_increase );
        dbms_output.put_line('Business ERROR !! You cannot increase employees’ salary by more than 20% !!');
    END IF;
END;

-- Trigger STOPSOARINGSALARY compiled
SET SERVEROUTPUT ON;

UPDATE employees
SET
    salary = 8000
WHERE
    employee_id = 199;
-- Business ERROR !! You cannot increase employees’ salary by more than 20% !!
-- Old Salary: 5184
-- New Salary: 6220.8
-- Salary Difference: 1036.8


-- Question 14 
-- Error Type: NO_DATA_FOUND exception.
DECLARE
    jobrecord jobs%rowtype;
BEGIN
    SELECT
        *
    INTO jobrecord
    FROM
        jobs
    WHERE
        jobs.job_title = 'Sales Agent';

    dbms_output.put_line('Job Sales Title :' || jobrecord.job_title);
EXCEPTION
    WHEN no_data_found THEN
        dbms_output.put_line('No job found with the title Sales Agent');
END;
-- No job found with the title Sales Agent
-- PL/SQL procedure successfully completed.


-- Question 15 
-- Error Type : TOO_MANY_ROWS exception.
DECLARE
    jobrecord jobs%rowtype;
BEGIN
    SELECT
        *
    INTO jobrecord
    FROM
        jobs
    WHERE
        jobs.job_title LIKE 'Sales%';

    dbms_output.put_line('Job Sales Title :' || jobrecord.job_title);
EXCEPTION
    WHEN too_many_rows THEN
        dbms_output.put_line('Error: Multiple jobs found with the title starting with "Sales". Please refine your search criteria to narrow down the results.');
END;
-- Error: Multiple jobs found with the title starting with "Sales". Please refine your search criteria to narrow down the results.
-- PL/SQL procedure successfully completed.
