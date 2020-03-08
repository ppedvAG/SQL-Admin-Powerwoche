/*
adhoc Abfragen

Sichten (Views)

gesp. Prozeduren (procedures)

functions



*/

a) select * from tabelle where sp = 100

b) select * from sicht

c) exec procdemo 

d) select * from f(wert) 

--von schnell nach langsam 
c  d b           a



--Wie funktionierts?

--adhoc Abfrage
select * from orders where orderid = 10250

--Sicht .. View.. (gemerkte Abfrage, wird wie Tabelle behandelt, 
--hat aber selbst keine Daten

create view vDemo
as
select * from orders where orderid > 10250;
GO

select * from vdemo



--Prozedur

create proc gpdemo
as
select * from orders where orderid = 10250;
GO

exec gpdemo


create function gpfuncDemo() returns table
as
begin

end

select * from gpfuncDemo()



Proc  schneller weil Plan schon vorliegt (
sicht wie adhoc

F() ist fast immer scheisse!!!
