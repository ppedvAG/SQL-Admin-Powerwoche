/*
Installation Feature SMTP

Einrichten des SMTP Server


in SQL Server
Verwaltung: Datenbankmail gemäß dem SMTP Server ein Profil einrichten

Profile 
	öffentlich: jeder aus der Rolle DatabasemailuserRole darf Mails versenden
	Privat: explizites Recht für das angebene Profil

Damit Aufträge Mails versenden können:
	im Agent (rechte MAus Eigensschaften im SSMS) Mailprofil aktivieren
	Agent neu starten

Jobs können nur an Operatoren gesendet werden
	Operator = Alias für Mails 
	--> Agent: Operatoren

Um Mails per TSQL zu senden: sp_Send_DBmail Prozedur


*/