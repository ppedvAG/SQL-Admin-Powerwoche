--INDIZES

/*
Gruppierter (clustered) IX
Nicht gr. (non cl) IX
Columnstore (ngr oder gr)..ab SQL 2012(ngr)..ab 2014 (gr)

Ausführungsplan
--Statistiken: Anzahl der Zeilen und Kosten (SQL Dollar)

Seek (Daten rauspicken) und Scan (A bis Z)

HEAP = Sauhaufen an Daten (Unsortiert)

NGR IX  bis zu 1000 pro Tabelle
Kopie der Daten
in sortierter Form

gut wenn durch das where rel wenig rauskommt
Kandidatenspalten für NGR IX: ID , GUID, PK
schlecht für: Religion, geschlecht

GRIX = TABELLE!!!
GR IX sortiert die Tabelle physikalisch neu auf
und bleibt sortiert.
Es gibt keinen HEAP mehr
gut, wenn im where <, > , between, like 'A%', =
der Gruppierte ix kann nur 1x gemacht werden
Ideale Kandidaten für CL IX: 
BestellDatum, Stadt.. welche spalte wird am meisten nach Bereichen durchsucht?






*/


use northwind



select * from customers

select * from customers

--spieltabelle
SELECT        Customers.CustomerID, Customers.CompanyName, Customers.City, Customers.Country, Orders.EmployeeID, Orders.OrderDate, Orders.Freight, [Order Details].UnitPrice, [Order Details].Quantity, 
                         [Order Details].ProductID, [Order Details].OrderID, Products.ProductName
INTO UMSATZ
FROM            Customers INNER JOIN
                         Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID INNER JOIN
                         Products ON [Order Details].ProductID = Products.ProductID

insert into UMSATZ
select * from UMSATZ
GO 7

--260000

select * from umsatz --TABLE SCAN

select orderid from UMSATZ where OrderID = 10248


set statistics io, time on 
--misst im Fenster Seiten und CPU in ms und Dauer in ms

--nach NIX_OID
--IX SEEK.. 3 Seiten und 0 ms

select freight, productname from UMSATZ where OrderID > 10248

select DB_ID()

select * from sys.dm_db_index_usage_stats where database_id=5

select * from umsatz


select * into umsatz2 from umsatz




select City, country from UMSATZ2 where freight = 0.02

select SUM(freight) from umsatz2 where ProductID = 10


select * from sys.dm_db_column_store_row_group_physical_stats

insert into umsatz2
select top 50000 * from umsatz



select SUM(unitprice*quantity) from UMSATZ where Country = 'UK'


select companyname from UMSATZ where City = 'Berlin'

select companyname from UMSATZ where City = 'London'

select companyname, productname from UMSATZ where City like '%'







