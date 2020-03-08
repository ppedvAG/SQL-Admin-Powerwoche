SELECT * FROM sys.dm_os_wait_stats 
      WHERE wait_type = 'CXPACKET'


select wait_type, status, * from sys.dm_exec_requests
where session_id = 59

select * from sys.dm_os_waiting_tasks
where wait_type = 'cxpacket'

