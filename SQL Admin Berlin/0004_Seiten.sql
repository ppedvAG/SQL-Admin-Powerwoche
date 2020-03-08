/*

jeder Datensatz kommt in Tabellen
aber Tabellen haben Strukturen Seiten bzw Blöcke

Seite hat immer 8192bytes davon sind 8060bytes Nutzlast
8 Seiten am Stück sind ein Block 64kb

1 DS muss i.d.R in eine Seite passen!!!!

Eine Seite kann auch nie mehr als 700 Slots für DS haben


Seiten werden 1:1 von HDD in RAM gelesen





*/



select * into t4 from t1


create table t6 (id int identity, spx char(4100))


--Grund für Dauer: TX TRansaction
declare @i as int = 0
begin tran
while @i < 20000
Begin	
	insert into t5 values('XY')
	set @i+=1
end
commit