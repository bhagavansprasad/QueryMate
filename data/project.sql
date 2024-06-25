--Project 

create database project
use project

create table roles(id int primary key,role_name varchar(100))

insert into roles values
(1,'A'),
(2,'B');

select * from roles

create table user_account
(id int primary key,
user_name varchar(100),
email varchar(254),
password varchar(200),
password_salt varchar(50) not null,
password_hash_algorithm varchar(50))

insert into user_account values(101,'raj','raj@gmail.com','raj123','###34','123456'),
(102,'rama','rama@gmail.com','rama123','###90','128907')

create table status(id int primary key,status_name varchar(100),is_user_working bit);

insert into status values(201,'completed','True'),(202,'pending','False')

select * from roles
select * from user_account
select * from status

create table user_has_role(id int primary key,role_start_time timestamp,
role_end_time datetime not null,user_account_id int foreign key references user_account(id),
role_id int foreign key references roles(id))

insert into user_has_role values(301,default,getdate(),101,1),(302,default,'2024-07-12',102,2)

select * from user_has_role

create table user_has_status(id int primary key,status_start_time timestamp,
status_end_time datetime not null,user_account_id int foreign key references user_account(id),
status_id int foreign key references status(id))

insert into user_has_status values(401,default,getdate(),102,201),(402,default,'2023-04-17',101,202)

select * from user_has_status

--deleting the data 
delete from user_has_role
delete from user_has_status
delete from roles
delete from user_account
delete from status
