--Security

--Login = Haustürschlüssel des Blocks
--Benutzer = Wohnungstürschlüssel 
USE [master]
GO
CREATE LOGIN [Max]
WITH PASSWORD=N'ZNljH4d5bYiiVcTqIxlY1CjI2jCkU3GthooJcdMbXi4=',
DEFAULT_DATABASE=[Northwind], 
DEFAULT_LANGUAGE=[Deutsch],
CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

CREATE LOGIN [Evi] WITH PASSWORD=N'VTD6CsoFNEIzIdrNBaaLotgnHQ65Fvo+gQ9OG0xd1HU='
, DEFAULT_DATABASE=[Northwind], 
DEFAULT_LANGUAGE=[Deutsch],
CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

uSe northwind

CREATE USER [Max] FOR LOGIN [Max] WITH DEFAULT_SCHEMA=[dbo]
GO

CREATE USER [Evi] FOR LOGIN [Evi] WITH DEFAULT_SCHEMA=[dbo]
GO

--Schema = Ordner

USE [Northwind]
GO
CREATE SCHEMA [IT] AUTHORIZATION [dbo]
GO


CREATE SCHEMA [MA] AUTHORIZATION [dbo]
GO


use northwind;

--ein paar IT Tabellen
create table it.mitarbeiter (itma int)
create table it.projekte (itpro int)

--ein paar MA Tabellen
create table ma.mitarbeiter (mama int)
create table ma.projekte (mapro int)


--jeder Benutzer hat ein Std Schema. wird keines angegeben, dann dbo

USE [Northwind]
GO
ALTER USER [Max] WITH DEFAULT_SCHEMA=[IT]
GO

ALTER USER [Evi] WITH DEFAULT_SCHEMA=[MA]
GO

use northwind
select * from customers

use [Northwind]
GO
GRANT SELECT ON SCHEMA::[IT] TO [Max]
GO
GRANT SELECT ON SCHEMA::[MA] TO [EVi]
GO

--Auf Tabelle direkt jemand ein Recht geben

GRANT SELECT ON [IT].[projekte] TO [Evi]
GO

--tabellen erstellen
use [Northwind]
GO
GRANT CREATE TABLE TO [Evi]
GO
GRANT ALTER ON SCHEMA::[MA] TO [Evi]
GO


--tabellen erstellen
use [Northwind]
GO
GRANT CREATE TABLE TO [Max]
GO
GRANT ALTER ON SCHEMA::[IT] TO [Max]
GO

--Rollen = Gruppe
--macht die Verwaltung deutlich leichter
--Datenbankrolle
CREATE ROLE [ITRolle] AUTHORIZATION [dbo]
GO
ALTER ROLE [ITRolle] ADD MEMBER [Max]
GO

--Max ZUgriff per Rolle
REVOKE ALTER ON SCHEMA::[IT] TO [Max] AS [dbo]
REVOKE SELECT ON SCHEMA::[IT] TO [Max] AS [dbo]
GO

GRANT SELECT ON SCHEMA::[IT] TO [ITRolle] --Max ist in Rolle
GO

--Neuer Fritz soll wie Max arbeiten
USE [master]
GO
CREATE LOGIN [Fritz] WITH PASSWORD=N'123',
DEFAULT_DATABASE=[Northwind], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [Northwind]
GO
CREATE USER [Fritz] FOR LOGIN [Fritz]
GO
ALTER ROLE [ITRolle] ADD MEMBER [Fritz]
GO


--

use [Northwind]
GO
GRANT CREATE VIEW TO [Evi]
GO
GRANT ALTER ON SCHEMA::[MA] TO [Evi]
GO





