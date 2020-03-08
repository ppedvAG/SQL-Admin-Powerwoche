--
create database partdb
GO

--3 DGR: bis100, bis200, rest, bis5000

USE [master]
GO
ALTER DATABASE [partdb] ADD FILEGROUP [bis100]
GO
ALTER DATABASE [partdb] ADD FILE ( NAME = N'partbis100', 
	FILENAME = N'C:\_STDINST\_Data\partbis100.ndf' , 
	SIZE = 1024KB , FILEGROWTH = 1024KB ) TO FILEGROUP [bis100]
GO
ALTER DATABASE [partdb] ADD FILEGROUP [bis200]
GO
ALTER DATABASE [partdb] ADD FILE ( NAME = N'partbis200', 
	FILENAME = N'C:\_STDINST\_Data\partbis200.ndf' , 
	SIZE = 1024KB , FILEGROWTH = 1024KB ) TO FILEGROUP [bis200]
GO
ALTER DATABASE [partdb] ADD FILEGROUP [bis5000]
GO
ALTER DATABASE [partdb] ADD FILE ( NAME = N'partbis5000', 
	FILENAME = N'C:\_STDINST\_Data\partbis5000.ndf' , 
	SIZE = 1024KB , FILEGROWTH = 1024KB ) TO FILEGROUP [bis5000]
GO
ALTER DATABASE [partdb] ADD FILEGROUP [Rest]
GO
ALTER DATABASE [partdb] ADD FILE ( NAME = N'partrest', 
	FILENAME = N'C:\_STDINST\_Data\partrest.ndf' , 
	SIZE = 1024KB , FILEGROWTH = 1024KB ) TO FILEGROUP [Rest]
GO


---zuerst die Funktion
use partdb;
GO
create partition function fzahl(int)
as
RANGE LEFT FOR VALUES (100,200)

-----------100]-------------200]-----------------
--   1              2                  3

select $partition.fzahl(117)--gibt nur den Bereich zurück


--nun das Part Scheme
create partition scheme schZahl
as
partition fzahl to (bis100, bis200, rest)
-----------------      1.     2.     3.

--die Tabelle auf scheme legen
create table parttab 
	(id int identity, nummer int, spx char(4100)) on schZahl(nummer)


declare @i int=0

while @i < 50000
begin
	insert into parttab values( @i, 'xy')
	set @i+=1
end



--Mannipulieren
--Grenze dazunehmen

--neue DGR
--F() anpassen.. neue Grenze definieren
--schema anpassen.. nimm neue DGR her

alter partition scheme schzahl next used bis5000;
GO

alter partition function fzahl() split range (5000);
GO

--Grenze entfernen
---f() + scheme

alter partition function fzahl() merge range (100);
GO

select	 $partition.fzahl(nummer) ,
		 min(nummer), 
		 max(nummer), 
		 count(*)
from parttab 
group by $partition.fzahl(nummer)

--???

CREATE PARTITION SCHEME [schZahl]
 AS PARTITION [fzahl] TO ([bis200], [bis5000], [Rest])
GO

CREATE PARTITION FUNCTION [fzahl](int) 
AS 
RANGE LEFT FOR VALUES (200, 5000)
GO

--Daten archivieren
--Ziel: Abfragen optimieren, die nicht nummer suchen
select * from parttab where id = 67 --52000 Seiten
create table archiv (id int not null, nummer int, spx char(4100))
		ON rest

alter table parttab switch partition 3 to archiv

select * from archiv
--Daten sind ins Archiv gewandert
--Annahme: 100MB /sek IO
--1000000000000MB ins Archiv... Dauer: 0
--es werden keine Daten verschoben
--Archivtabelle muss in der gleichen DGR sein


--Segmentieren der DAten nach Datum

CREATE PARTITION FUNCTION [fBestelldatum](datetime) 
AS 
RANGE LEFT FOR VALUES ('31.12.2015 23:59:59.999', '1.1.2017')
GO

CREATE PARTITION FUNCTION [fBestelldatum](date) --!!!
AS 
RANGE LEFT FOR VALUES ('31.12.2015', '1.1.2017')
GO

--Kunden nach A bis Z
--a bis g  h bis r und rest
CREATE PARTITION FUNCTION [fnachname](varchar(50)) 
AS 
RANGE LEFT FOR VALUES ('Gzzzzzzzzzz','s')
GO



CREATE PARTITION SCHEME [schZahl]
 AS PARTITION [fzahl] TO ([PRIMRAY],[PRIMRAY],[PRIMRAY])--Sinn
GO

---immer dieselbe Datei!






















--großer Schwung an daten in Rest

--Seek(Huhn), Scan (Flachbettscanner)
set statistics io on
select * from parttab where nummer = 1170
select * from parttab where id = 117


--

















