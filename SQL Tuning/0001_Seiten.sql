USE northwind

/*
DS werden in Seiten gespeichert.
1 Seite hat 8192 bytes davon 8060 Nutzlast
1 DS muss reinpassen


*/

--geht nicht
CREATE TABLE t1 (id INT IDENTITY, sp1 CHAR(4100), sp2 CHAR(4100))

CREATE TABLE t1 (id INT IDENTITY, sp1 varCHAR(4100), sp2 CHAR(4100))
GO

INSERT INTO T1
SELECT 'X', 'Y'
GO 20000 -- 8 Sekunden..SSD

--Frage: wie groß ist die Tabelle?

--1DS hat mehr als 4030bytes.. 1 DS = 1 Seite --> 20000 seiten (8kb)

SET STATISTICS IO ON
SELECT * FROM t1 --logische Lesevorgänge 20000..aber nur ca 51% daten
--Anzeige des verlusts
DBCC SHOWCONTIG('T1')
/*
- Gescannte Seiten.............................: 20000
- Gescannte Blöcke..............................: 2504
...
- Mittlere Seitendichte (voll).....................: 50.85%
*/
--20000 Seiten auch im RAM 

/*
1 MIO DS .. 1 DS 4100
Lösung: Datentypen.. evtl statt 4100 byte unter 4031, 
    dann würden 2 DS in eine Seite passen
    dann statt 8GB (HDD und RAM) nun 4 GB (HDD und RAM)

    --Anwendung geht nimmer!



*/

USE nwindbig
DBCC SHOWCONTIG()


SELECT * INTO t2 FROM t1












