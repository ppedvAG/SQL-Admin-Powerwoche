--TaskManager
--evtl Prozesse, die nicht da sein sollten
--AV Software
--SQL Server muss nicht der Schuldige sein
--im Taskmanager versteckt sich auch der Zugriff auf den Ressourcenmonitor
-- der eine noch genauere Übersicht liefert

--Aktivitätsmonitor (sysprocesses)
--der Taskmanager des SQL Server
--alle Prozesse über 50 sind Prozesse der User
--live Ansicht.. hsitorische Werte hier nicht erkennbar
--man findet hier auch auf folgendes:
-- Warteressourcen der letzte Sekunde
--Top Abfragen nach Ressourcenverbrauch
--Sperren

--Evtl muss aber aufgezeichnet werden:
--Profiler (TSQL Statements aufzeichnen
--Perfom (grafische Analyse von Leistungsindikatoren (Windows auch SQLS erver)

--beide lassen sich übereinander legen..dazu muss allerdings eine Profiler-
--aufzeichnung geladen werden, und dann per Datei -- Leistungsdaten importieren

--!! Profiler ist abgekündigt.. Ersatz XEvents.. allerdings ist der Vergleich mit 
--dem Perfmon so nicht mehr machbar
--dafür kann man mit XEvents deutlich genauer und effektiver (spez bei Abfragen)
--Enpässe eruiren. Würde ich aber unter "Fortgeschritten" einreihen


--Zur Analyse immer auch DMVs. So gut wie alle Auswertungen, Berichte etc im SSMS
--werden durch DMVs erstellt.

--DMV der letzte Schliff der Analyse




--vereinfachtes Vorgehen bei Fehlersuche
/*
1. Taskmanager, Ressourcenmonitor
2. Live-Problem (a) oder Problem bereits wieder verschwunden (b)

--Live
2 (a) DMVs, Ressourcemonitor, Aktivitätsmonitor, evtl Profiler
--Aufzeichnung
2 (b) XVents, Profiler, DMVs, Perfmon









select * from sys.dm_os_wait_Stats

select * from sys.dm_os_