--Messverfahren CXPACKETE

set statistics profile on
select T1.[Key],T1.[Data],T2.[Data] From HugeTable1 T1 Join [HugeTable2] T2 ON T1.[Key] =T2.[Key] where T1.Data < 100 OPTION (MAXDOP 3)
 go 1000
