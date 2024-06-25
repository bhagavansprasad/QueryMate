--DDL(Create, alter, drop)
Structure 
--Dml(
--################################

Create database DEMO

use DEMO

CREATE TABLE Department
  (
      did INT,
      ename VARCHAR(50) ,
      gender VARCHAR(50) ,
      salary INT ,
      dept VARCHAR(50) 
   )
--DML (Data manipulation Language)
--Add/ modify / delete  records in my tabale 
--Syntax:
--	Insert  into tablename (col1, col2, col3, col4 , col5)
--	values (val1, val2, val3, val4 , val5)

--current database name =master
use demo
	insert into Department(did, ename, gender,salary, dept)
	values (101, 'alpha','male',5000, 'it')

		insert into Department	values
		(102, 'beta','male',50009, 'it'),
		(103, 'char','female',5000, 'FIN'),
		(104, 'delta','male',50600, 'HR'),
		(105, 'echo','female',5400, 'it'),
		(106, 'test','male',50010, 'it'),
		(107, 'lima','female',50200, 'sales')
--Null (absent , unavailable)
	insert into Department	values
	(108,NUll ,NULL,NULL, 'it')


--Select (read records from table)
	select did, ename, gender,salary, dept from department

	select did,  gender, dept from department

	select dept  from department

	select *  from department

	select gender,salary,did, ename,  dept from department

--Update 
	select *  from department
	update  tablename 
	set col1=value, col2= val, col3= val


	update Department 
	set ename ='raju', gender ='male', dept ='it'
	where did =107

	update Department 
	set ename ='alex', gender ='male', salary =876543
	where did =108


	update Department 
	set salary =999999
	
	select *  from department
--delete 
	--delete  from tablename where COL= values 
	delete from Department where did =102

	delete from Department where did in (100, 102,103, 105, 107, 108)
	
	delete from Department 

	
	select *  from department

--############################################################
CREATE DATABASE school;
USE school;

CREATE TABLE Teachers (
    TeacherID INT,
    Name VARCHAR(20),
    Age INT,
    Class VARCHAR(20)
);

CREATE TABLE Students (
    StudentID INT,
    FirstName VARCHAR(20),
    LastName VARCHAR(20),
    Age INT,
    Class VARCHAR(20),
    TeacherID INT
);

CREATE TABLE Courses (
    CourseID INT,
    CourseName VARCHAR(50),
    Department VARCHAR(20),
    TeacherID INT
);

CREATE TABLE Departments (
    DepartmentID INT,
    DepartmentName VARCHAR(20)
);

CREATE TABLE Enrollments (
    EnrollmentID INT,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE
);

CREATE TABLE Teachers_Departments (
    TeacherDepartmentID INT,
    TeacherID INT,
    DepartmentID INT
);

--############################################################
CREATE DATABASE hospital;
USE hospital;

CREATE TABLE Doctors (
    DoctorID INT,
    FirstName VARCHAR(20),
    LastName VARCHAR(20),
    Specialization VARCHAR(20),
    Age INT
);

CREATE TABLE Patients (
    PatientID INT,
    FirstName VARCHAR(20),
    LastName VARCHAR(20),
    Age INT,
    AdmissionDate DATE,
    DischargeDate DATE,
    DoctorID INT
);

CREATE TABLE Departments (
    DepartmentID INT,
    DepartmentName VARCHAR(20),
    HeadDoctorID INT
);

CREATE TABLE Nurses (
    NurseID INT,
    FirstName VARCHAR(20),
    LastName VARCHAR(20),
    Age INT,
    DepartmentID INT
);

CREATE TABLE Medications (
    MedicationID INT,
    MedicationName VARCHAR(50),
    Dosage VARCHAR(20)
);

CREATE TABLE Prescriptions (
    PrescriptionID INT,
    PatientID INT,
    DoctorID INT,
    MedicationID INT,
    PrescribedDate DATE,
    DosageInstructions VARCHAR(100)
);









































































































































































































































































































































































































































































































