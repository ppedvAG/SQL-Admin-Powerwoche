/*
Master
die DB!
Settings, konfiguration, DB, Logins
Sichern nach �nderung


model
Vorlage f�r neue DBS.. ==> default settings einer neuen db: Wachstum, initialgr��e., recoverymodel...
Sichern, wenn sich was �ndert
evtl per Script Restoren..


msdb
DB f�r den Agent (Jobs, Mailsystem, Wartungsplan, SSIS , Historie der Jobs..)
Sichern nach jeder �nderung


tempdb
Zeilenversionierung, #t, ##t , IX Erstellung, Sortieren, Auslagerungsvorg�nge
keine Sicherung




*/

--Wartung .. Wartungsplan