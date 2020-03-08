/*
BACKUP

V ollst�ndige Sicherung

sichert alle Daten zu einem Zeitpunkt weg
zuerst wird ein Checkpoint ausgef�hrt

CHECKPOINT -- Daten aus dem Puffer auf den Datentr�ger schreiben
best�tigte Daten werden gebackupt

kennt die Dateien , deren Pfade und Gr��e




D ifferentielle Sicherung
Differenz zum V
Checkpoint



T ransaktionsprotokolsicherung
sichert den Weg zu den aktuellen Daten
jeder INS UP DEL wird protokolliert
man kann auf Sek restoren


V TTT D TTT D TTT
V           D TTT

ohne D
V TTT    TTT   TTT

was ist der schnelsste restore den man haben kann?
nur V ..also umso h�ufiger V desto besser

Wie lange dauert der Restore dieses "T"?
dauert solange, wie die Aktionen im T dauerten
also..nicht zuviele Ts auflaufen lassen

ein T ist kaputt!
V TTx!T TTTT TTTT D TTTT
entweder
V TT
V                  D TTTT

ergo.. nie zuviele Ts und immer wieder Ds einstreuen


Das T h�ngt allerdings von einem sog Wiederherstellungsmodell ab
W.-Model regelt, was ins Protkoll kommt

Jede DB hat
FULL
T speichert jede �nderung in der DB exakt
daher Restore auf Sekunde



BULK
funktioniert wie Simple
aber!!   kein Leeren des T
Jetzt muss ein T Sicherung passieren
Denn nur die Sicherung des T leert das T
Restore geht auf Sekunden genau, aber nur dann 
wenn kein BULK stattfand



SIMPLE
I U D werden protokolliert
Bulk wieder nur geringf�gig protkolliert
Nach Commit verschwindne die Eintr�ge aus dem T
keine Sicherung des T m�glich
Wann Simple: TestDb zb

Welches Model nehm ich denn?

TestdD: einfach
ProduktionsDBs >= Bulk
AvGr: FULL
Spiegeln: Full
Logshipping: mind Bulk

Wie lange darf der Server ausfallen?
Wieviel Datenverlust darf ich haben?

Gr��e der DB: 40GB
Zeiten : 6 bis 22 Uhr
Mo bis Fr
Ausfallzeit der DB/Server: 2 Std
Datenverlust: 15min
am besten so gut wie nix verlieren
--nur mit W-Model Full kann man so exakt wie m�glich restoren

--> FULL
--> T Sicherung: 15min
--> D Sicherung: alle 4 T max
--> V jeden Tag einmal

--Sicherungen f�r V D T
---> V TTT D TTT D TTT

*/
--FULL
BACKUP DATABASE [Northwind] TO  DISK = N'C:\_SQLBACKUPS\Northwind.bak'
	WITH NOFORMAT,
	NOINIT,  NAME = N'Northwind Full', 
	SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
--DIFF
BACKUP DATABASE [Northwind] TO  DISK = N'C:\_SQLBACKUPS\Northwind.bak' 
	WITH  DIFFERENTIAL , 
	NOFORMAT, NOINIT,  
	NAME = N'Northwind Diff', 
	SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
--TLog
BACKUP LOG [Northwind] TO  DISK = N'C:\_SQLBACKUPS\Northwind.bak'
	WITH NOFORMAT, NOINIT, 
	NAME = N'Northwind-Tlog', 
	SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO




*/

--FALL 1 : DB Defekt..HDD kaputt
--restore �ber Datenbanken... wiederherstellen.. Medium w�hlen 
--evtl Pfade anpassen

--Fall 2: DB ok.. aber Daten verschf�lscht
--DB restoren unter anderen Name
--evtl Pfade od Dateinamen anpassen
--Dann per TSQL OrgDB updaten


--Fall3 : Org DB restoren zu einem best Zeitpunkt

use northwind;
GO


create table test1 (id int identity, spx datetime)


insert into test1
select getdate()
GO 30000

--Sind Backups Online oder Offline: ONLINE!!
--Restore ist immer offline

select * from test1 order by spx desc



--Protkollfragment = der ungesicherte Teil des Tlog
--Nettes Gimmik des SSMS: man kauch einen best Zeitpunkt restoren
--der noch  gar nicht gesichert wurde. Bei jedem Restore schl�gt das SSMS
--ein Backup des Protkollfragments vor. ;-)


--Fall 4: Was , wenn ich weiss, dass was passieren wird...
--> SNAPSHOT

/*
D: (10 MB frei)
DBXY 50 GB

Resultat: SN_DBXY1200 (lesbare DB)
alle Daten aus der DBXY von 12 sind darin
--nicht ver�nderlich immer 12 Uhr Daten

*/

--Snapshot



USE master
GO


-- Create the database snapshot
CREATE DATABASE DBName
ON
( NAME = Northwind -- = Logischer Name der Datendatei der OrgDB
, FILENAME = 'C:\_SQLDBS\SN_DBDAteiname.mdf' ) --Name der Snapshot Datendatei
AS SNAPSHOT OF OrgDBName;
GO


CREATE DATABASE SN_Northwind_1215
ON
( NAME = Northwind -- = Logischer Name der Datendatei der OrgDB
, FILENAME = 'C:\_SQLDBS\SN_Northwind_1215.mdf' ) --Name der Snapshot Datendatei
AS SNAPSHOT OF Northwind;
GO

select * from northwind..customers
select * from sn_northwind_1215..customers

--Restore
--von master DB aus
--keiner darf auf den DBs sein!
use master

Restore database northwind
from database_Snapshot = 'SN_northwind_1215'

--Feststellen der DBID
select db_id('northwind')-- 5
select db_id('sn_northwind_1215')-- 8


--alle Benutzersessions haben ein spid > 50
select * from sysprocesses 
	where spid > 50 and dbid in (5,8)

--54..60

kill 54
kill 60



--Fragen zu Snapshot...

-- kann man die OrgDB backupen ..  na klar
--kann man den Snapshot sichern.. nee.. was willst mit einer leeren Datei?

--kann man den Snapshot restoren..h��?? kann man ja nicht backupen
--kann man die OrgDB restoren?... Neee..geht nicht...
--man muss vorher alle Snapshots l�schen

--kann man mehr Snapshots haben? .. Ja


--Sicherungen

--100GB
--Mo bis Fr
--6 bis 22 Uhr
--Datenverlust 15 min
--Server/DBAusfall: max 5 min (Reaktionszeit)
--geringtm�glicher Datenverlust

--V  : dauert max 15min...1 x t�glich: 22:20 Uhr (mo bis Fr)
--T: 15min (mo bis fr ; 6:15 bis 22:15)
--D: alle 4 Ts (mo bis fr; 7:20 bis 21:20)

--wenn die Zeit nicht mehr reicht, dann HADR (Hochverf�gbarkeit)


















