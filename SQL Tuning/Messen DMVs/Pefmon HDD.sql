--Perfom Disk
PhysicalDisk: Avg. Disk Queue Length: Verrät die durchschnittliche Anzahl der Anfragen 
    die auf Festplattenzugriff warten. Werte größer 2 sind bereits problematisch.
PhysicalDisk: % Disk Time: Prozentsatz der Zeit, bei der die Disk 
    mit Schreibe- oder Leseoperationen beschäftigt ist. 
    Wenn der Wert 90% überschreitet, sollte man den folgenden Counter mitberücksichtigen:
PhsicalDisk: Current Disk Queue Length: Anzahl der im Moment auf Festplattenzugriff wartenden Anfragen.
Memory: Page Faults/sec: Ja, dieser RAM-Counter hat auch seine Auswirkung auf die Festplattenüberwachung! 
    Damit kann man herausfinden, ob exzessives Paging für die Festplattenaktivität verantwortlich ist.