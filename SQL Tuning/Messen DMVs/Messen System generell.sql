select * from sys.dm_exec_connections

select * from sys.dm_exec_sessions where session_id> 50

select * from sys.dm_os_workers

select r.session_id, r.status, r.command, t.pending_io_count
from sys.dm_exec_requests r
join sys.dm_os_tasks t on r.task_address = t.task_address
order by 1 desc

select 8060/269

select 3200000/29
