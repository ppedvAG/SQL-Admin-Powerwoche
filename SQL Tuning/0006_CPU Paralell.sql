set statistics io on --Seiten
set statistics time on -- Dauer --- ms der CPU Last


select country, sum(freight) 
from Customers c inner join orders o
on c.CustomerID=o.CustomerID
group by country

EXEC sys.sp_configure N'cost threshold for parallelism', N'50'
GO
EXEC sys.sp_configure N'max degree of parallelism', N'3'
GO
RECONFIGURE WITH OVERRIDE
GO

select * from sys.dm_os_wait_stats where wait_type like 'CX%'