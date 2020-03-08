/*
Master
die DB!
Settings, konfiguration, DB, Logins
Sichern nach Änderung


model
Vorlage für neue DBS.. ==> default settings einer neuen db: Wachstum, initialgröße., recoverymodel...
Sichern, wenn sich was ändert
evtl per Script Restoren..


msdb
DB für den Agent (Jobs, Mailsystem, Wartungsplan, SSIS , Historie der Jobs..)
Sichern nach jeder Änderung


tempdb
Zeilenversionierung, #t, ##t , IX Erstellung, Sortieren, Auslagerungsvorgänge
keine Sicherung




*/

--Wartung .. Wartungsplan