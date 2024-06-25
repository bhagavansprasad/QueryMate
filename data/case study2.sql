create database casestudy2
use casestudy2

CREATE TABLE LOCATION (
  Location_ID INT PRIMARY KEY,
  City VARCHAR(50)
);

INSERT INTO LOCATION (Location_ID, City)
VALUES (122, 'New York'),
       (123, 'Dallas'),
       (124, 'Chicago'),
       (167, 'Boston');


  CREATE TABLE DEPARTMENT (
  Department_Id INT PRIMARY KEY,
  Name VARCHAR(50),
  Location_Id INT,
  FOREIGN KEY (Location_Id) REFERENCES LOCATION(Location_ID)
);


INSERT INTO DEPARTMENT (Department_Id, Name, Location_Id)
VALUES (10, 'Accounting', 122),
       (20, 'Sales', 124),
       (30, 'Research', 123),
       (40, 'Operations', 167);

	   CREATE TABLE JOB (
  Job_ID INT PRIMARY KEY,
  Designation VARCHAR(50)
);

CREATE TABLE JOB
(JOB_ID INT PRIMARY KEY,
DESIGNATION VARCHAR(20))

INSERT  INTO JOB VALUES
(667, 'CLERK'),
(668,'STAFF'),
(669,'ANALYST'),
(670,'SALES_PERSON'),
(671,'MANAGER'),
(672, 'PRESIDENT')


CREATE TABLE EMPLOYEE
(EMPLOYEE_ID INT,
LAST_NAME VARCHAR(20),
FIRST_NAME VARCHAR(20),
MIDDLE_NAME CHAR(1),
JOB_ID INT FOREIGN KEY
REFERENCES JOB(JOB_ID),
MANAGER_ID INT,
HIRE_DATE DATE,
SALARY INT,
COMM INT,
DEPARTMENT_ID  INT FOREIGN KEY
REFERENCES DEPARTMENT(DEPARTMENT_ID))

INSERT INTO EMPLOYEE VALUES
(7369,'SMITH','JOHN','Q',667,7902,'17-DEC-84',800,NULL,20),
(7499,'ALLEN','KEVIN','J',670,7698,'20-FEB-84',1600,300,30),
(7505,'DOYLE','JEAN','K',671,7839,'04-APR-85',2850,NULl,30),
(7506,'DENNIS','LYNN','S',671,7839,'15-MAY-85',2750,NULL,30),
(7507,'BAKER','LESLIE','D',671,7839,'10-JUN-85',2200,NULL,40),
(7521,'WARK','CYNTHIA','D',670,7698,'22-FEB-85',1250,500,30)

--Simple Queries

--1. List all the employee details.
/*2. List all the department details.
3. List all job details.
4. List all the locations*/

select * from employee
select * from department
select * from job
select * from location

--5. List out the First Name, Last Name, Salary, Commission for all Employees.
select first_name,last_name,salary,comm from employee

/*6. List out the Employee ID, Last Name, Department ID for all employees and
alias
Employee ID as "ID of the Employee", Last Name as "Name of the
Employee", Department ID as "Dep_id".*/Select EMPLOYEE_ID as [Id of the Employee] ,
Last_Name as [Name of the Employee], 
DEPARTMENT_ID as [Dep_Id] from Employee

--7. List out the annual salary of the employees with their names only.SELECT CONCAT(First_Name, ' ', Last_Name) AS EmployeeName, Salary*12  AS AnnualSalaryFROM EMPLOYEE;
--or
SELECT First_name+' '+Last_name AS EmployeeName, Salary*12  AS AnnualSalaryFROM EMPLOYEE;

--WHERE Condition:
--1. List the details about "Smith".
select * from employee where last_name='smith' or first_name='smith'

--name--> first_name

--2. List out the employees who are working in department 20.
select * from employee where department_id=20

--3. List out the employees who are earning salary between 2000 and 3000.
select * from employee where salary between 2000 and 3000

--4. List out the employees who are working in department 10 or 20.
select * from employee where department_id=20 or department_id=10--orselect * from employee where department_id in (10,20)--5. Find out the employees who are not working in department 10 or 30.select * from employee where department_id not in (10,30)
--6. List out the employees whose name starts with 'L'.
select * from employee where first_name like 'L%' or last_name like 'L%'

--7. List out the employees whose name starts with 'L' and ends with 'E'.SELECT * FROM EMPLOYEE WHERE First_Name LIKE 'L%E';

--or
SELECT * FROM EMPLOYEE WHERE First_Name LIKE 'L%' and first_name like '%E';

--8. List out the employees whose name length is 4 and start with 'J'
SELECT * FROM EMPLOYEEWHERE first_Name LIKE 'J___';

--or

SELECT * FROM EmployeeWHERE LEN(First_Name) = 4 AND First_Name LIKE 'J%'

--9. List out the employees who are working in department 30 and draw the
--salaries more than 2500

SELECT * FROM EMPLOYEEWHERE DEPARTMENT_ID=30 and salary>2500

--10. List out the employees who are not receiving commission.
SELECT * FROM EMPLOYEEWHERE comm is null

--ORDER BY Clause:

--1. List out the Employee ID and Last Name in ascending order based on the
--Employee ID.
select employee_id, last_name from employee order by employee_id

--2. List out the Employee ID and Name in descending order based on salary.
select employee_id, first_name from employee order by salary desc

--3. List out the employee details according to their Last Name in ascending-order
select * from employee order by last_name asc

--4. List out the employee details according to their Last Name in ascending
--order and then Department ID in descending order.
select * from employee order by last_name asc,department_id desc

--GROUP BY and HAVING Clause:
--1. List out the department wise maximum salary, minimum salary and
--average salary of the employees.
select department_id,max(salary)as max_salary,min(salary) as min_salary,
avg(salary)as avg_salary from employee group by DEPARTMENT_ID

--2. List out the job wise maximum salary, minimum salary and average
--salary of the employees.select job_id,max(salary)as max_salary,min(salary) as min_salary,
avg(salary)as avg_salary from employee group by job_ID--3. List out the number of employees who joined each month in ascending order.select count(employee_id)as number_of_employees, month(hire_date)as month_of_hiring from employeegroup by month(hire_date) order by month(hire_date)