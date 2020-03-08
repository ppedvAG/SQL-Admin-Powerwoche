sp_configure 'show advanced options', 1
GO
RECONFIGURE
GO 
sp_configure 'blocked process threshold', 0
GO 
RECONFIGURE 
GO 



select * from sys.sysprocesses where spid = 59