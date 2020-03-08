CREATE TABLE dbo.Customer
(
    Id    INT        NOT NULL  IDENTITY(1,1),
    Name  CHAR(100)  NOT NULL,
    Ort   CHAR(100)  NOT NULL
);
GO
 
-- Füllen der Demotabelle mit 1.000 Datensätzen
DECLARE @i INT = 1;
WHILE @i <= 10000
BEGIN
    INSERT INTO dbo.Customer (Name, Ort)
    VALUES ('Kunde ' + CAST(@i AS VARCHAR(10)), 'Frankfurt am Main');
 
    SET @i += 1;
END
GO
 
-- Aktualisierung von 10 Datensätzen für hohe Selektivität
UPDATE dbo.Customer
SET    Ort = 'Erzhausen'
WHERE  Id % 1000 = 0;
GO

select * from customer


-------------------------------------------------
DBCC TRACEON(-1, 3604,1200) WITH NO_INFOMSGS;

--------------------------------------------------
--TEST
--Die Tabelle ist ein heap.. alle Seiten werden gesperrt
--READ COMMITED: es wurden nur Seiten gelesen, die Committed sind
--da HEAP macht Sperren auf Seiten Sinn
--intent shared Lock: um mögliche Lockescalationen durchzuführen
--das Objekt kann nicht durch andere Sperren blockiert werden:

--READ COMMITED: keine Zeilensperren!! auch bei Index, da keine Datenänderungen durchgeführt werden


SELECT * FROM dbo.Customer WHERE Id = CAST(10 AS int);

SELECT * FROM dbo.Customer WHERE Ort = 'Frankfurt am Main';


----READ UNCOMMITED
--Dirty Reads möglich..führt aber zu Shared Lock Sch-S.. keine Änderungen an Tab.
--Bulk_operation -S Sperre: kein Lesen auf neue unformatierte Datenseiten während des Lesens

set transaction isolation level read uncommitted

SELECT * FROM dbo.Customer WHERE Id = CAST(10 AS int);

SELECT * FROM dbo.Customer WHERE Ort = 'Frankfurt am Main';


------REPEATABLE READ
set transaction isolation level repeatable read 
--Zeilensperren auf jede Zeile Shared.. und danach wieder freigegegen
--bis auf die entrepchende Zeile, die erst am ende der Transaction freigfegeben wird
--.. erst am Ende der Transaction kann man wieder ändern

SELECT * FROM dbo.Customer WHERE Id = CAST(10 AS int);

SELECT * FROM dbo.Customer WHERE Ort = 'Frankfurt am Main';


SELECT sys.fn_physlocformatter(%%physloc%%) AS Position, * FROM dbo.Customer WHERE Id = CAST(10 AS int);


set transaction isolation level Serializable
--kompletter Tabellen Scan.. Komplette Sperre für Änderungen auf HEAP
--

SELECT * FROM dbo.Customer WHERE Id = CAST(10 AS int);

SELECT * FROM dbo.Customer WHERE Ort = 'Frankfurt am Main';


-----NUN INDIZIERTE TABELLEN
CREATE UNIQUE CLUSTERED INDEX ix_Customer_Id ON dbo.Customer (Id);
CREATE INDEX ix_Customer_Ort ON dbo.Customer (Ort) INCLUDE (Name);

--READ COMMITED
--Hier wird nunr noch die entprechende Datenseite gesperrt
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT * FROM dbo.Customer WHERE ID = CAST(10 AS INT) ;

--READ UNCOMMITED
--Nur noch Shcmea Sperre um Änderungen an der tabelle zu verhindern
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM dbo.Customer WHERE Ort = 'Erzhausen';

--READ REPEATABLE READ
--Datensatz muss unverändert bleiben..Zeilensperre
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT * FROM dbo.Customer WHERE Id = CAST(10 AS INT);

DBCC TRACEON (3604);

DBCC PAGE ('TEST1', 1, 27296, 3) WITH TABLERESULTS;
--Ausgabe: Slot 9 Offset 0x7cb Length 211	Slot 9 Offset 0x0 Length 0 Length (physical) 0	KeyHashValue	(d08358b1108f)

--SERIALIZABLE
--Bereichssperre.. es darf kein weitere DS zwischen den gesperrten eingefügt werden
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT * FROM dbo.Customer WHERE Id BETWEEN 10 AND 20;