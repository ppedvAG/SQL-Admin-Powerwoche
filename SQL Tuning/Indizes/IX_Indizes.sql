--Indizes

/*
x Clustered IX (gruppiert)
x NON CL IX 
----------------------------------
x eindeutiger IX
x gefilterter IX
x IX mit eingeschl Spalten
x zusammengsetzten IX
x partitionierten IX
x indizierte Sicht
realer hypothetischer IX
x abdeckender IX
--------------------------------------
ColumnStore IX


*/

select Sp, Sp from tabe where !!

/*

=
<
>
between
in
!=
like 'A%'
like '%A'
not ..
*/

select * from bestellungen --PK auf BNr als CLustered
select * from orders

select * into best4 from best3

--SCAN : von a bis Z
--SEEK: "picken"

select * from bestellungen where bdatum < '1.1.1998'

set statistics io on
set statistics time on

drop view vbest
create view dbo.vBest with schemabinding
as
select country , count_big(*) as Anzahl from dbo.best
group by country



select * from vBest



create table t12 (id int, sp1 int, sp2 int)

create view vt12 as select * from t12

select * from vt12


alter table t12 add sp3 int


select * from customers c inner join orders o
on o.CustomerID=c.CustomerID


select * from customers c inner loop join orders o
on o.CustomerID=c.CustomerID

select * from customers c inner hash join orders o
on o.CustomerID=c.CustomerID



select * from orders where 
	freight = 10 or (city = 'Berlin' AND productname = 'Tea')




select * into best2 from best

--413MB bei 2 Mio Zeilen

select country, sum(unitprice*quantity) from best
group by country where city = 'berlin'


select country, sum(unitprice*quantity) from best2 --9MB
group by country



--Index wartung:

--Reorg  ab 5/10%  
--Rebuild ab 30%


--200MB Heap.. 1 GR + 2 Ngr--- > 363MB
--Rebuild offline (online) | mit Hilfe der tempdb
--Platzbedarf während des Rebuild: 860 bis 11xx MB

--Ola Hallengren






