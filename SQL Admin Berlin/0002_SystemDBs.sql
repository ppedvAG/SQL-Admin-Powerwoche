--SystemDBs
--regelm�ssig Sichern per Wartungsplan


/*
master
Herzchen
Konfiguration des SQL Server
Logins
Datenbanken


Backup: ohne master ist SQL Server tot!

model
keine Bilder
>Vorlage f�r neue DBs
create database testdb (model als Kopie)
alle Einstellung der model 
Backup der Model DB:
..besser als Script!!

USE [master]
GO
ALTER DATABASE [model] SET COMPATIBILITY_LEVEL = 100
GO



msdb
DB f�r den Agent (jobs, emailsystem, Warnungen, Verlauf der Jobs, Wartungspl�ne, SSIS Pakete)

Backup: Jaaaaahh!!!!



tempdb
#tab, ##tab, IX Erstellung, Zeilenversionierung
BACKUP: hihih nein!


*/