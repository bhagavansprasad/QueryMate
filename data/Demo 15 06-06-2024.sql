--Exception  error handling, case in Sql server 


--##########################################################################
--error message (multi lang)
 select * from sys.messages
 where message_id=207


 select  ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_STATE(),ERROR_PROCEDURE()


 select 1+'a'

 
Create table test101
(sno int  unique, Eventss varchar(20))

insert into test101 values 
(101, 'alpha')

select * from test101


--TO overcome 
/*
	Begin Try
			--SQL stmt
	end Try

	Begin Catch
			--generate Errors
			--Write to table
	end Catch
*/

	Begin Try
			--SQL stmt
			insert into test101 values (101, 'alpha')
	end Try

	Begin Catch
			--generate Errors
			print 'duplicate data'
	end Catch



	Begin Try
			--SQL stmt
			SELECT 1/0
	end Try

	Begin Catch
			--generate Errors
			print 'Divide by zero error encountered.
'
	end Catch
--------------------------------------------------
	Begin Try
			--SQL stmt
			SELECT 1/0
	end Try

	Begin Catch
			--generate Errors
			 select  ERROR_MESSAGE(),ERROR_LINE(),ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_STATE(),ERROR_PROCEDURE()

	end Catch

--#########################################################
---- Capture errors
	create table errors
	(
		sno int identity,
		timestamps datetime default getdate(),
		ERRORLINE varchar(200),
		ERRORMESSAGE varchar(200),
		ERRORNUMBER varchar(200), 
		ERRORSTATE varchar(200),
		ERRORSEVERITY varchar(200), 
		ERRORPROCEDURE varchar(200)
	)

--#################################################


	Begin Try
			--SQL stmt
			insert into test101 values (101, 'alpha')
			insert into test101 values (102, 'alpha')
			insert into test101 values (103, 'alpha')
	end Try

	Begin Catch
			--generate Errors
			INSERT INTO errors(ERRORLINE ,ERRORMESSAGE ,ERRORNUMBER, ERRORSTATE ,ERRORSEVERITY,	ERRORPROCEDURE)
			 VALUES (ERROR_LINE(),ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_STATE(),ERROR_SEVERITY(),ERROR_PROCEDURE())
	end Catch

--#################################################


	Begin Try
			--SQL stmt
			SELECT 1/0
	end Try

	Begin Catch
			--generate Errors
			INSERT INTO errors(ERRORLINE ,ERRORMESSAGE ,ERRORNUMBER, ERRORSTATE ,ERRORSEVERITY,	ERRORPROCEDURE)
			 VALUES (ERROR_LINE(),ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_STATE(),ERROR_SEVERITY(),ERROR_PROCEDURE())
	end Catch
--#################################################


	Begin Try
			--SQL stmt
			insert into test101 values  (102, 'alpha'), (103, 'alpha'),(101, 'alpha')

	end Try

	Begin Catch
			--generate Errors
			INSERT INTO errors(ERRORLINE ,ERRORMESSAGE ,ERRORNUMBER, ERRORSTATE ,ERRORSEVERITY,	ERRORPROCEDURE)
			 VALUES (ERROR_LINE(),ERROR_MESSAGE(),ERROR_NUMBER(),ERROR_STATE(),ERROR_SEVERITY(),ERROR_PROCEDURE())
	end Catch

--#################################################
	SELECT * FROM test101
	SELECT * FROM errors




--#################################################

BEGIN TRY 
	BEGIN TRAN 
		--SQL LOGIC 1
			 BEGIN TRY 
				--SQL LOGIC2 


			END TRY 

	
			Begin Catch
					--generate Errors
					--Write to table
			end Catch

END TRY 

	
Begin Catch
			--generate Errors
			--Write to table
end Catch

--#########################################
	Begin Try
			--SQL stmt
			SELECT 1/0
	end Try

	Begin Catch
			--generate Errors
			RAISERROR('YOU CANNOT DIVIDE', 16,1)

	end Catch

--#####################################################################
--Transaction control language

select * from Department


delete from Department


    INSERT INTO Department  VALUES
  (1, 'David', 'Male', 5000, 'Sales'),
  (5, 'Shane', 'Female', 5500, 'Finance'),
  (6, 'Shed', 'Male', 8000, 'Sales'),
  (7, 'Vik', 'Male', 7200, 'HR'),
  (2, 'Jim', 'Female', 6000, 'HR'),
  (13, 'Julie', 'Female', 7100, 'IT'),
  (14, 'Elice', 'Female', 6800,'Marketing'),
  (3, 'Kate', 'Female', 7500, 'IT'),
  (4, 'Will', 'Male', 6500, 'Marketing'),
  (10, 'Laura', 'Female', 6300, 'Finance'),
  (11, 'Mac', 'Male', 5700, 'Sales'),
  (12, 'Pat', 'Male', 7000, 'HR'),
  (8, 'Vince', 'Female', 6600, 'IT'),
  (9, 'Jane', 'Female', 5400, 'Marketing'),
  (15, 'Wayne', 'Male', 6800, 'Finance')



delete from Department

  select * from department
--Transaction control language
begin transaction --( time )

--2024-06-06T23:04:25.8308413-04:00

--select,insert , update , delete 

insert into t2 
select * from  t1


  select * from department

  
delete from Department

Commit --save 

Rollback --dont save 


---#####################################################################
begin transaction --( time )

--2024-06-06T23:08:10.9480786-04:00

--select,insert , update , delete 



  select * from department

  
delete from Department where did <10

Commit --save 

Rollback --dont save 




---#####################################################################

dbcc sqlperf(logspace)




Create table test101
(sno int  , Eventss varchar(20))

begin  transaction 
insert into test101 values 
(101, 'alpha')
 go 5000

select * from test101

rollback


insert into test101 values 
(101, 'alpha')
 go 5000

select * from test101


--#####################################################################
/*
	CASE
		WHEN condition1 THEN result1
		WHEN condition2 THEN result2
		WHEN condition3 THEN result3
		...
		ELSE default_result
	END
*/



select did,ename,gender,dept,salary,
		case 
			 when salary <=5000 then salary *1.5
			 when salary  between 5001 and 6000 then salary *1.4
			 when salary  between 6001 and 6800 then salary *1.3
			 when salary  between 6801 and 7900 then salary *1.2
			 when salary >=7901 then salary *1.1
		end as Newdata from Department

update Department 
set salary =case 
				 when salary <=5000 then salary *1.5
				 when salary  between 5001 and 6000 then salary *1.4
				 when salary  between 6001 and 6800 then salary *1.3
				 when salary  between 6801 and 7900 then salary *1.2
				 when salary >=7901 then salary *1.1
			end 

select did,ename,gender,dept,salary from department
---Transaction log file 
	select * from fn_dblog(null, null)

--paul randall( transaction  log file )
	DBCC TRACEON(3604);

	dbcc page ('sqldemo', 1,9,3)


































































































































































































































































































































































































































































































































































































