/*Indizes
N CL IX .. gut für rel eindutige Ergebnisse durch where

CL IX gut für Bereichsabfragen (between, > <)

CL = Tabelle in pyhsikal. sortierte Form nur 1*
HEAP hat keine CL IX

NCL ist zusätzliche Struktur zu Heap od CL IX

massive Beschleunigung bei Abfragen
aber evtl auch kontraproduktiv bei INS UP DEL

Wartung von IX wichtig!

Scan = Suche von vorne bis hinten (alles)
Seek = Treffer.. direktes Finden des Datensatzes
!! PK oft schlecht als CL IX! Kann man über Tabellen entwurf --> INdizes-- auf NCL ändern

DMV für IX


sys.dm_db_index_usage_Stats
sys.dm_db_pyhsical_Stats(db_id('dbname'),object_id('Tabellenname'), NULL, NULL, 'detailed')





*/


select * from customers



--TABLE SCAN vs CL IX SCAN  gleich

--CL IX SCAN vs NCL IX SCAN

--NCL IX SCAN vs NCL IX SEEK

--NCL IX SEEK--> HEAP
--NCL IX SEEK--> CL IX



