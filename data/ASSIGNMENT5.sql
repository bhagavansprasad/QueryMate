--ASSIGNMENT 5

--1. Arrange the �Orders� dataset in decreasing order of amount
SELECT * FROM ORDERS ORDER BY AMOUNT DESC

--2. Create a table with the name �Employee_details1� consistingof 
--thesecolumns: �Emp_id�, �Emp_name�, �Emp_salary�. 
--Create another tablewiththe name �Employee_details2� consisting of the same columns asthefirst
--table.

CREATE TABLE EMPLOYEE_DETAIL1
(
EMP_ID INT,
EMP_NAME VARCHAR(20),
EMP_SALARY INT
)

CREATE TABLE EMPLOYEE_DETAIL2
(
EMP_ID INT,
EMP_NAME VARCHAR(20),
EMP_SALARY INT
)

SELECT * FROM EMPLOYEE_DETAIL1
SELECT * FROM EMPLOYEE_DETAIL2

INSERT INTO EMPLOYEE_DETAIL1 VALUES
(1,'A',30000),
(2,'B',70000),
(3,'C',80000)

INSERT INTO EMPLOYEE_DETAIL2 VALUES
(3,'C',80000),
(4,'D',90000),
(5,'E',50000)

TRUNCATE TABLE EMPLOYEE_DETAIL1

--3. Apply the UNION operator on these two tables

SELECT * FROM EMPLOYEE_DETAIL1
UNION
SELECT * FROM EMPLOYEE_DETAIL2

--UNION ALL
SELECT * FROM EMPLOYEE_DETAIL1
UNION ALL
SELECT * FROM EMPLOYEE_DETAIL2

--4. Apply the INTERSECT operator on these two tables
SELECT * FROM EMPLOYEE_DETAIL1
INTERSECT
SELECT * FROM EMPLOYEE_DETAIL2

--5. Apply the EXCEPT operator on these two tables
SELECT * FROM EMPLOYEE_DETAIL1
EXCEPT
SELECT * FROM EMPLOYEE_DETAIL2

SELECT * FROM EMPLOYEE_DETAIL2
EXCEPT
SELECT * FROM EMPLOYEE_DETAIL1