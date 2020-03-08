--Indizes

/*
x Gruppierter IX  -nur einmal pro Tab, besonders gut bei Bereichsabfragen
x Nicht gruppierter IX --bis ca 1000 pro Tab.. gut bei wenigen ergebnisse
----------------------------
x IX mit eingeschl. Spalten --select Spalten
x zusammeng. IX  (max 16 Spalten) --where Spalten
x Indi. Sicht -- Specialfall mit vielen Limits
partionierter ix --physilkalische SPlittung der IX Seiten
x gefilterter IX --nicht alle Datensätze
x abdeckende IX --reiner Seek
x eindeutiger IX --
------------------------------
Columnstore IX-- Seit SQL 2012 die Top Neuerung
--Besondern gut durch BatchModus, CPU, hdd und daher auch ram schonend
--Super beim lesen, da nur die Daten in die Hand genommen werden, die auch verarbeitet werden sollen
-- Nachteile: bei OLTP kaum zu verwenden:
---> Es werden bei Updates ganze Rowgroups gesperrt, Datensätze werden nicht wirklich gelöscht
---> Neue ds werden in bnormale seiten geschrieben
---> bis Tupple Mover ab einer best. Anzahl korrigiert
--< Größter Vorteil durch extreme Kompressionsraten
--< daher auch deutlich geringere RAM Verbrauch


ABC

A

ABC
ACB
BCA
BAC
CAB
CBA

ca 1000 auch bei 3 Spalten potentiell möglich

HEAP: unsortierter Sauhaufen..
Heaps können fprward_record_Counts aufweisen.. 
==> zusätzliche Zugriffe auf Seiten, da evtl bei Änderungen an Tabellen die neuen Daten an anderen stellen abgelegt wurden
--> alter table t1 add sp varchar(50) zb

NG IX : gut bei wenigen Ergebnissen (ID spalten bspw)
-->Telefonbuch

GR IX: bei Bereichsabfragen, auch wenn mal mehr rauskommt
-->Tabelle ist physikalisch sortiert
--> gibt es nur einmal pro Tabelle


*/

select * from kundendemo --PK wird default als CL IX

--PK als gruppierter IX ist oftmals pure Verschwendung
--Einen id wert hätte auch sehr gut ein non cl ix erledigt

select newid()

select * from customers

insert into customers (customerid, companyname) values ('ppedv', 'ppedvag')



SELECT        Customers.CustomerID, Customers.CompanyName, Customers.City, Customers.Country, Orders.OrderDate, Orders.Freight, Orders.EmployeeID, [Order Details].ProductID, [Order Details].UnitPrice, 
                         [Order Details].Quantity, Products.ProductName, Employees.LastName, Employees.FirstName, Employees.BirthDate
INTO KundeUmsatz
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID INNER JOIN
                         Products ON [Order Details].ProductID = Products.ProductID

insert into kundeUmsatz
select * from kundeumsatz
go 12

--bisher ein HEAP!
alter table kundeumsatz add kuid int identity

select * from kundeumsatz --Table Scan

dbcc showcontig('kundeumsatz') --- Gescannte Seiten.............................: 55785

set statistics io on
select * from kundeumsatz

--KundeUmsatz-Tabelle. Scananzahl 1, logische Lesevorgänge 101354???
--bessere Methode zur Untersuchung des physiklaischen Layouts..
select * from sys.dm_db_index_physical_stats(db_id(), object_id('kundeumsatz'),NULL,NULL, 'detailed')

--orderdate als cl ix... nach CL IX ist ein forward_record_count geschichte

--Suchen nach eine best ID
select kuid, country from kundeumsatz where kuid = 100

--und wenn nohc mehr im Select gefragt wird ..zb *..IX mit eingeschlossenen Spalten

select * from kundeumsatz where kuid = 100


select * from kundeumsatz where country = 'UK' and city = 'London'

select country, city , count (*) from kundeumsatz
group by country, city with rollup


select * from kundeumsatz where kuid < 100 and country = 'Germany'

--was wenn 2 Indizes gleich gut wären:
--er nimmt den mit der kleineren id

--Übersicht: verwendung der IX: Seek vs scan.. schelcht sind die, die immer NULL, NULL, NULL aufweisen
select * from sys.dm_db_index_usage_stats where object_id = object_id('kundeumsatz')


set statistics time on
select country , count(*) from kundeumsatz
group by country

create view dbo.vdemo with schemabinding
as
select country , count_big(*) as Anzahl from dbo.kundeumsatz
group by country

select * from vdemo

--1 Trillion DS umsätze aus 2000 bis 2017
---Umsatz pro land

--Seiten wenn eine Ind. Sicht verwendet werden würde?
--250..2 bis 3 Seiten
--0 sek Abfrage


--2Mio DS... neue Tabelle ist ein HEAP..identity
select * into k2 from kundeumsatz

select top 3 * from k2

--Vergleich normale tabelle mit Columnstore IX

select companyname, sum(unitprice*quantity)
		from kundeumsatz
		group by companyname


select companyname, sum(unitprice*quantity)
		from k2
		group by companyname

-----------------------------------------------
select companyname, sum(unitprice*quantity)
		from kundeumsatz where freight < 10
		group by companyname


select companyname, sum(unitprice*quantity)
		from k2-- where freight < 10
		group by companyname


select top 3 * from k2

select country,sum(freight) from kundeumsatz
where productid = 1 and quantity < 10
group by country


select country,sum(freight) from k2
where productid = 1 and quantity < 10
group by country --wieder besser

--IX Wartung------------------------------------------------

--<5-10% Fragementierung: nix
--> 30% : Rebuild
-- dazwischen: Reorg
--Tipp: bis inkl SQL Managm Studio 2014 keinen Wartungsplan verwenden
--besser: ola Hallengreen: Maintenance Solution.sql
--ab SQL Server Manag-Studio 2016 : perfekt


--wie ?

--Tools zum Auffinden geeigneter IX

--TSQL Abfragefenster: IX-Hinweis in grün im Ausführungsplan

--Workload für Profiler
select * into o1 from orders

select * from o1 where orderid < 10261

select freight from o1 where orderdate between '1.1.1996' and '31.12.1996'

select sum(freight) , employeeid from o1
	where customerid like 'BLAUS'
	group by employeeid

select * from customers c inner join o1 on o1.CustomerID=c.CustomerID
	where shipcountry in ('USA', 'UK')
	order by city desc






