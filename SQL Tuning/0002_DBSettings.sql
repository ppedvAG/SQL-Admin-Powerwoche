--DB Setting

create database testdb

/*
Initialgröße: bis 2014 5MB DB
Wachstum: Daten 1 MB; LOG 10%

ab 2016:
DB 8MB ..Anfangsgröße sollte das sein, wie groß die DB in ca 3 Jahren sein wird
Wachstum 64MB
LOGFile  64MB


VLF (Restore)..LogFile sollte nie wachsen





*/


--recoveryModel:

/*

simple
I,UP, DEL,  BULK nur rudimentär
Logfile wird automatisch geleert, sp. durch VollSicherung

keine LogSicherung möglich (keine Restore auf beliebigen zeitpunkt)
weniger!

bulk
I, UP, DEL, BULK nur rudimentär
Logfile wird nicht automatisch geleert
Erst duch Sicherung des Logfiles



full
ausführlich auch Bulk protokolliert
IX
auf sek restore möglich
aufwendiger


*/

--default: FULL, weil die model auch auf full steht!



select * from fn_virtualfilestats(db_id(), 2)



Tabelle: Seite 1000
beim Lesen: 1600!!!


/*
Diagramm
PKs, dann auch referenzen
datetime beim GebTag??
varchar bei flexiblen Längen !
---

Sichten , Prozeduren , F()


Sicht:
= eine Abfrage
keine Daten

Performance:
egal.. gleich schnell

Anwendungsgebiet:
komplexe abfragen vereinfachen
wiedervendbar
Security
werden wie Tabellen behandelt

nie mit Select *
am besten immer mit schemabinding


--Prozeduren
wie batch
Performance: i.d.R schneller
nie benutzerfreundlich !


F()
sind fast immer schei****
nur die Tabelleinlinef()
verwenden nur eine CPU
machen fast immer einen SCAN
f() im Where um eine Spalte  where f(spa) = 10 !!!!! GRRRRR


TRigger können massiv Datentransfer auslösen..

Inserted und Deleted Tabellen für die Daten, die entweder INS, UP, DEL werden














--