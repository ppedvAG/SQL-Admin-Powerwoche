create database testdb

--Viele Fehler
--: 

/*
DB besteht aus normalerweise aus 2 Dateien:  .mdf   .ldf

Wie groß sind die beiden? seit SQL 2016 8MB beide
Um wieviel wachsen die Dateien: 64MB seit SQL 2016
--Logfile war früher 10%

Besser wäre kein Wachstum , sondern genügend Platz: Wie groß in 3 Jahren!!
--Vergrößerungsraten zB 1 GB
--Logfiles nie in % vergrößern lassen

--So hätte es bei SQL 2014 ausgesehen

USE [testdb]
GO
DBCC SHRINKFILE (N'testdb' , 5)
GO
USE [testdb]
GO
DBCC SHRINKFILE (N'testdb_log' , 2)
GO
USE [master]
GO
ALTER DATABASE [testdb] MODIFY FILE ( NAME = N'testdb', FILEGROWTH = 1024KB )
GO
ALTER DATABASE [testdb] MODIFY FILE ( NAME = N'testdb_log', FILEGROWTH = 10%)
GO

Developer haben keinen Bock per TSQL diese Daten anzugeben!!




*/

use testdb

create table t1 (id int identity, spx char(4100))

--varchar(500)
select 20000*4/1000


insert into t1
select 'XY'
GO 20000


/*

1DS hat ca 4100bytes (51% einer Seite)
20000 Seiten * 8kb --> 160MB

Messbar?


*/

dbcc showcontig('t1')

-- Gescannte Seiten.............................: 20000
-- Mittlere Seitendichte (voll).....................: 50.79%
--Wieviel MB : 


*/


create table t3 (id int identity, spx varchar(4100))

--varchar(500)
select 20000*4/1000


insert into t3
select 'XY'
GO 20000


dbcc showcontig('t3')