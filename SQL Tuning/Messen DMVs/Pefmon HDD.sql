--Perfom Disk
PhysicalDisk: Avg. Disk Queue Length: Verr�t die durchschnittliche Anzahl der Anfragen 
    die auf Festplattenzugriff warten. Werte gr��er 2 sind bereits problematisch.
PhysicalDisk: % Disk Time: Prozentsatz der Zeit, bei der die Disk 
    mit Schreibe- oder Leseoperationen besch�ftigt ist. 
    Wenn der Wert 90% �berschreitet, sollte man den folgenden Counter mitber�cksichtigen:
PhsicalDisk: Current Disk Queue Length: Anzahl der im Moment auf Festplattenzugriff wartenden Anfragen.
Memory: Page Faults/sec: Ja, dieser RAM-Counter hat auch seine Auswirkung auf die Festplatten�berwachung! 
    Damit kann man herausfinden, ob exzessives Paging f�r die Festplattenaktivit�t verantwortlich ist.