--SOS_YIELD_Scheduler
--Angenomme es laufen sehr viele Threads und SQL Server ist voll beschäftigt
--dann kann SQL Server slebst entscheiden, ob einige Threads freiwillig einem anderen Thread Vorfahrt 
--geben entsteht ein SOS_YIELD_Scheduler Wait
--ist unter runnable_tasks_count eine 2stellige Zahl ist die CPU unter Stress

SELECT scheduler_id , current_tasks_count , runnable_tasks_count , work_queue_count , pending_disk_io_count 
FROM sys.dm_os_schedulers 
WHERE scheduler_id < 255 
GO


--Welche Abfrage sind das..total_worker_time hoch =CPU Pressure
--evtl IX Defrag!!
SELECT SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
((CASE qs.statement_end_offset
WHEN -1 THEN DATALENGTH(qt.TEXT)
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2)+1),
qs.execution_count,
qs.total_logical_reads, qs.last_logical_reads,
qs.total_logical_writes, qs.last_logical_writes,
qs.total_worker_time,
qs.last_worker_time,
qs.total_elapsed_time/1000000 total_elapsed_time_in_S,
qs.last_elapsed_time/1000000 last_elapsed_time_in_S,
qs.last_execution_time,
qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.total_worker_time DESC -- CPU time