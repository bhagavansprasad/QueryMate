--ASSIGNMENT 2

create database assignment

use assignment

--1. Create a customer table which comprises of these columns: ‘customer_id’,
--‘first_name’, ‘last_name’, ‘email’, ‘address’, ‘city’,’state’,’zip’.

CREATE TABLE CUSTOMER
(
CUSTOMER_ID INT,
FIRST_NAME VARCHAR(20),
LAST_NAME VARCHAR(30),
EMAIL VARCHAR(20),
ADDRESS VARCHAR(50),
CITY VARCHAR(20),
STATE VARCHAR(20),
PINCODE INT);

--2. Insert 5 new records into the table
INSERT INTO CUSTOMER VALUES
(1,'GAGAN','SINGH','GS@GMAIL.COM','12323 VICTORIA PLACE','SAN JOSE','USA',787890),
(2,'GITA','SINGH','GS@YAHOO.COM','12323 VICTORIA PLACE','BANGLORE','INDIA',78990),
(3,'RAJ','PAL','RP@GMAIL.COM','12323 VICTORIA PLACE','JAIPUR','RAJ',700090),
(4,'SITA','MIA','SM@OUTLOOK.COM','12323 VICTORIA PLACE','LUCKNOW','UP',787890),
(5,'UDIT','SHARMA','USS@YAHOO.COM','12323 VICTORIA PLACE','SAN JOSE','USA',787790)

--3. Select only the ‘first_name’ and ‘last_name’ columns fromthe customer table
SELECT FIRST_NAME,LAST_NAME FROM CUSTOMER

--4. Select those records where ‘first_name’ starts with “G” and city is ‘SanJose’. 
SELECT * FROM CUSTOMER WHERE FIRST_NAME LIKE 'G%' AND CITY='SAN JOSE'

--5. Select those records where Email has only ‘gmail’
SELECT * FROM CUSTOMER WHERE EMAIL LIKE '%GMAIL%'

--6. Select those records where the ‘last_name’ doesn't end with “A”.
SELECT * FROM CUSTOMER WHERE LAST_NAME NOT LIKE '%A'
