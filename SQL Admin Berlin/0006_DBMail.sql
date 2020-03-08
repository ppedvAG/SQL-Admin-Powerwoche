/*
Installation Feature SMTP

Einrichten des SMTP Server


in SQL Server
Verwaltung: Datenbankmail gem�� dem SMTP Server ein Profil einrichten

Profile 
	�ffentlich: jeder aus der Rolle DatabasemailuserRole darf Mails versenden
	Privat: explizites Recht f�r das angebene Profil

Damit Auftr�ge Mails versenden k�nnen:
	im Agent (rechte MAus Eigensschaften im SSMS) Mailprofil aktivieren
	Agent neu starten

Jobs k�nnen nur an Operatoren gesendet werden
	Operator = Alias f�r Mails 
	--> Agent: Operatoren

Um Mails per TSQL zu senden: sp_Send_DBmail Prozedur


*/