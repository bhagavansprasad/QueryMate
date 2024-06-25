--Trigger In SQl server, ddl , dml , XML.

--##########################################################################
Create database SQLDEMO

use SQLDEMO


Create procedure Sp_readinfo @tname varchar(20)
as
begin 
	declare @data nvarchar(max)
	set @data='Select * from ' +@tname
	execute Sp_executesql @data
end 

CREATE TABLE Department
  (
      did INT,
      ename VARCHAR(50) ,
      gender VARCHAR(50) ,
      salary INT ,
      dept VARCHAR(50) 
   )


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


  SELECT * FROM Department


  exec Sp_readinfo department




--###################################################
--Trigger( event --Action)
	--DML(Insert , update, delete)
	--Two logical Tables 
		--Inserted (add a new record, update of new data)
		--Deleted(remove a record, update and remove data)

/*
SYNTAX
	Create trigger triggername 
	on tablename
	for insert, update, delete
	as 
	sql logic

*/

--TRIGGER on Department 

--Historical table 


  SELECT * FROM Department

--Department istory table 
Create table histdept 
(	sno int identity(1,1),
	Timestamps datetime default getdate(),
	Loginame varchar(50) default suser_name(),
	DML_OPS varchar(20),
	Old_did int ,
	Old_ename  varchar(50), 
	Old_salary int,
	New_did int ,
	New_ename  varchar(50), 
	New_salary int,

)
 select * from Department 

--DML Trigger insert 
	Create Trigger TG_Insert 
	on Department 
	for Insert
	as
	insert into histdept (DML_OPS ,	Old_did ,Old_ename, Old_salary ,New_did ,New_ename,	New_salary )
	select 'Insert', NULL, NULL, NULL, DID, Ename, Salary  from inserted


--INSERT INTO Department 
INSERT INTO Department  VALUES
  (13, 'David', 'Male', 5000, 'Sales'),
  (53, 'Shane', 'Female', 5500, 'Finance'),
  (63, 'Shed', 'Male', 8000, 'Sales')


 select * from Department 

  select * from histdept 

--DML Trigger Delete 
	Create Trigger TG_Delete
	on Department 
	for Delete
	as
	insert into histdept (DML_OPS ,	Old_did ,Old_ename, Old_salary ,New_did ,New_ename,	New_salary )
	select 'Delete', DID, Ename, Salary, NULL, NULL, NULL  from deleted


	
delete from Department 

 select * from Department 

  select * from histdept 

-- Enable/ disable a trigger
	Enable TRIGGER trigger_name ON table_name;

	DISABLE TRIGGER trigger_name ON table_name;

--Drop trigger trigger name 

DROP TRIGGER [dbo].[TG_Insert]




--DML Trigger Update 
	Create Trigger TG_Update
	on Department 
	for Update
	as
	insert into histdept (DML_OPS ,	Old_did ,Old_ename, Old_salary ,New_did ,New_ename,	New_salary )
	select 'Update', D.DID, D.Ename, D.Salary, I.DID, I.Ename, I.Salary
	from deleted D join inserted I
	on D.did=I.did


 select * from Department 

  select * from histdept 

  update Department 
  set ename = 'unknown ' , salary =0

--###############################################################
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100)
)

CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    Amount DECIMAL(10,2),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)
	)
CREATE TABLE OrderLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    LogDate DATETIME,
    Description VARCHAR(255)
);

CREATE TRIGGER trg_AfterOrderUpdate
ON Orders
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Log new orders
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO OrderLog (OrderID, LogDate, Description)
        SELECT OrderID, GETDATE(), 'New order placed'        FROM inserted;
    END

    -- Log updated orders
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO OrderLog (OrderID, LogDate, Description)
        SELECT i.OrderID, GETDATE(), 'Order updated from ' + CAST(d.Amount AS VARCHAR) + ' to ' 
		+ CAST(i.Amount AS VARCHAR)
        FROM inserted i        JOIN deleted d ON i.OrderID = d.OrderID
        WHERE i.Amount <> d.Amount; -- Logs only when the amount changes
    END
END;
GO

INSERT INTO Customers (CustomerName, Email) VALUES ('John Doe', 'john.doe@example.com');
INSERT INTO Customers (CustomerName, Email) VALUES ('Jane Smith', 'jane.smith@example.com');


INSERT INTO Orders (CustomerID, OrderDate, Amount) VALUES (1, GETDATE(), 150.00);
INSERT INTO Orders (CustomerID, OrderDate, Amount) VALUES (1, GETDATE(), 200.00);
INSERT INTO Orders (CustomerID, OrderDate, Amount) VALUES (2, GETDATE(), 250.00);



UPDATE Orders
SET Amount = 180.00
WHERE OrderID = 1;

select * from orders



select * from orderlog


select cast(1 as varchar) + '-a-'+ cast(2 as varchar)
--############################################################################
--DDL Trigger (Create_Table,ALter_Table, Drop_Table)
/*

	Create trigger triggername 
	on Database
	for Create_Table,ALter_Table, Drop_Table
	as 
	sql logic

*/
--Capture the DDL events on the database 
Create table DDLHIST
(sno int identity, Events xml)

	Create trigger DDL_HIst 
	on database 
	for Create_Table,ALter_Table, Drop_Table
	as
	 insert into DDLHIST values( EVENTDATA())


Create table demo1 (id int ,age int , phnum int)

 alter table demo1 
 drop column id

drop table demo1
select * from DDLHIST
--xml --varchar()



select sno 
,[Events].value('(/EVENT_INSTANCE/EventType)[1]','varchar(100)') as Events
,[Events].value('(/EVENT_INSTANCE/ServerName)[1]','varchar(100)') asServerName
,[Events].value('(/EVENT_INSTANCE/DatabaseName)[1]','varchar(100)') DatabaseName
,[Events].value('(/EVENT_INSTANCE/ObjectName)[1]','varchar(100)') ObjectName
,[Events].value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','varchar(100)') CommandText

from DDLHIST

-- Force my user not to crete a atable which has a Temp name 

Create trigger Mon_tbname 
on database 
for Create_Table,ALter_Table, Drop_Table 
as 

begin 
	declare @tablename nvarchar(100)
	set @tablename =eventdata().value('(/EVENT_INSTANCE/ObjectName)[1]','varchar(100)')
	if @tablename like '%Temp%'
	begin 
		print 'You are not allowed to create a table with name having TEMP'
		rollback
	end


end



Create table demo2 (id int ,age int , phnum int)

Create table tempdemo (id int ,age int , phnum int)


----##########################################################################
CREATE TABLE XmlDataStore (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    XmlContent XML,
    Description VARCHAR(255)
);


-- Record 1
INSERT INTO XmlDataStore (XmlContent, Description)
VALUES ('<Customer><Name>John Doe</Name><Email>john.doe@example.com</Email></Customer>', 'First customer data');

-- Record 2
INSERT INTO XmlDataStore (XmlContent, Description)
VALUES ('<Customer><Name>Jane Smith</Name><Email>jane.smith@example.org</Email></Customer>', 'Second customer data');

-- Record 3
INSERT INTO XmlDataStore (XmlContent, Description)
VALUES ('<Customer><Name>Emily Johnson</Name><Email>emily.johnson@example.net</Email></Customer>', 'Third customer data');

-- Record 4
INSERT INTO XmlDataStore (XmlContent, Description)
VALUES ('<Customer><Name>Michael Brown</Name><Email>michael.brown@example.com</Email></Customer>', 'Fourth customer data');

-- Record 5
INSERT INTO XmlDataStore (XmlContent, Description)
VALUES ('<Customer><Name>Lucy Lee</Name><Email>lucy.lee@example.org</Email></Customer>', 'Fifth customer data');



select * from XmlDataStore

INSERT INTO XmlDataStore (XmlContent, Description)
VALUES (
    '<Customer>
             <Name>John</Name>
            <Name>Michael</Name>
            <Name>Doe</Name>
       
        <Email>john.doe@example.com</Email>
    </Customer>',
    'First customer data with detailed name'
);




select ID
,XmlContent.value('(/Customer/Name)[1]','varchar(100)') as FName
,XmlContent.value('(/Customer/Name)[2]','varchar(100)') as MName
,XmlContent.value('(/Customer/Name)[1]','varchar(100)') as LName
,XmlContent.value('(/Customer/Email)[1]','varchar(100)')as Email
, Description
from XmlDataStore


update XmlDataStore

set XmlContent.modify('replace value of (/Customer/Name/text())[1] with "Raj Kumar"')
where ID=1

























































































































































































































