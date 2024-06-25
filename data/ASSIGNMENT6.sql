--ASSIGNMENT 6

SELECT * FROM CUSTOMER

--1. Create a view named ‘customer_san_jose’ 
--which comprises of onlythosecustomers who are from San Jose.
CREATE VIEW customer_san_jose
AS SELECT * FROM CUSTOMER WHERE CITY='SAN JOSE'

SELECT * FROM customer_san_jose

--2. Inside a transaction, update the first name of the customer to Franciswhere the last name is Jordan:
--a. Rollback the transaction
--b. Set the first name of customer to Alex, where the last nameisJordan

BEGIN TRANSACTION

UPDATE CUSTOMER SET FIRST_NAME='Francis' WHERE LAST_NAME='PAL'

ROLLBACK TRANSACTION

BEGIN TRANSACTION

UPDATE CUSTOMER SET FIRST_NAME='ALEX' WHERE LAST_NAME='PAL'

COMMIT

--ROLLBACK TRANSACTION

--3. Inside a TRY... CATCH block, divide 100 with 0, print the default error
--message.

begin TRY
SELECT 100/0 
END TRY

BEGIN CATCH
SELECT ERROR_MESSAGE() AS ERRORMESSAGE
END CATCH

--4. Create a transaction to insert a new record to Orders table and saveit

SELECT* FROM ORDERS

BEGIN TRANSACTION

INSERT INTO ORDERS VALUES(107,GETDATE(),4000,9)

COMMIT