--DMV Data Management View (F())
--_OS = SQL Server
-- _DB = Datenbank

select * from sys.dm_db_index_usage_stats where database_id = db_id('northwind')


Brent Ozar -- sp_blitzIndex


select * from sys.dm_db_index_Physical_Stats(db_id(), object_id('orders'), NULL, NULL, 'detailed')

--index_id = 0 --> HEAP
--           1 --> CL IX
--           >=2 --> N CL IX

--object_id = Tabelle


select * from orders where customerid like '%A'