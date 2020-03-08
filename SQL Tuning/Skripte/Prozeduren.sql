use northwind;
GO


create procedure gpKundenLand @Land varchar(50)
as
select * from customers where country =@Land


exec gpKundenLand @land='USA'

--Was ist schneller : PROC vs Abfrage??
--Proc ist schneller, weil der Plan schon vorliegt!!
--proceduren enthalten oft komplette BI Logik
--INS, UP del SEL, create frop alter




