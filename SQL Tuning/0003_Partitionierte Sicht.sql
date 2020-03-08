--Partitionierte Sicht
--statt einer sehr großen Tabelle lieber viele kleinere

--Umsatztabelle wächst von Jahr zu Jahr


use kadb;
GO

create table u2017 (id int identity, jahr int, spx char(4100)) --theoretisch auf andere DGR
create table u2016 (id int identity, jahr int, spx char(4100))
create table u2015 (id int identity, jahr int, spx char(4100))

--aber die APP sagt: wo ist mein Umsatz????

select * from umsatz where jahr = 2015

--??


create view Umsatz 
as
select * from u2017
UNION ALL--nicht nach doppelten Zeilen suchen..UNION alleine macht distinct
Select * from u2016
UNION ALL
select * from u2015

--Plan anschauen!
select * from umsatz where jahr = 2016
--die Sicht enthält keine Daten!!..
--es werden alle 3 Tabellen gescant
--ich will aber nur eine (u2016) verwenden müssen
--constraint.. Check Einschränkung

ALTER TABLE dbo.u2015 ADD CONSTRAINT
	CK_u2015 CHECK ((jahr=2015))

ALTER TABLE dbo.u2016 ADD CONSTRAINT
	CK_u2016 CHECK ((jahr=2016))

ALTER TABLE dbo.u2017 ADD CONSTRAINT
	CK_u2017 CHECK ((jahr=2017))

select * from umsatz where jahr = 2016--trara: nur noch 2016 Tabelle

insert into umsatz (id, jahr, spx) values (1,2016,'xy')

--leider ist der Identity Wert nicht erlaub, daher muss die App
--den ID Wert wieder selber vergeben.. APP Redesign..
--Wegen der Sicht muss ein PK auf ID und jahr gelegt werden, damit ejder Datensatz in der Sicht eindeutig wird

--Sobald also eine partitionierte Sicht schreiben soll, wird es zum Anwendungsredesign kommen müssen
--







