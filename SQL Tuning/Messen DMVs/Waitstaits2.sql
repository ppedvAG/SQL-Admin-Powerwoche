select database_id, file_id
    ,io_stall_read_ms
    ,num_of_reads
    ,cast(io_stall_read_ms/(1.0+num_of_reads) as numeric(10,1)) as 'avg_read_stall_ms'
    ,io_stall_write_ms
    ,num_of_writes
    ,cast(io_stall_write_ms/(1.0+num_of_writes) as numeric(10,1)) as 'avg_write_stall_ms'
    ,io_stall_read_ms + io_stall_write_ms as io_stalls
    ,num_of_reads + num_of_writes as total_io
    ,cast((io_stall_read_ms+io_stall_write_ms)/(1.0+num_of_reads + num_of_writes) as numeric(10,1)) as 'avg_io_stall_ms'
from sys.dm_io_virtual_file_stats(null,null)
order by avg_io_stall_ms desc

--Nützliche Indizes
select d.*
        , s.avg_total_user_cost
        , s.avg_user_impact
        , s.last_user_seek
        ,s.unique_compiles
from sys.dm_db_missing_index_group_stats s
        ,sys.dm_db_missing_index_groups g
        ,sys.dm_db_missing_index_details d
where s.group_handle = g.index_group_handle
and d.index_handle = g.index_handle
order by s.avg_user_impact desc
go
--- suggested index columns and usage
declare @handle int

select @handle = d.index_handle
from sys.dm_db_missing_index_group_stats s
        ,sys.dm_db_missing_index_groups g
        ,sys.dm_db_missing_index_details d
where s.group_handle = g.index_group_handle
and d.index_handle = g.index_handle

select * 
from sys.dm_db_missing_index_columns(@handle)
order by column_id

--- top 50 statements by IO
SELECT TOP 50
        (qs.total_logical_reads + qs.total_logical_writes) /qs.execution_count as [Avg IO],
        substring (qt.text,qs.statement_start_offset/2, 
         (case when qs.statement_end_offset = -1 
        then len(convert(nvarchar(max), qt.text)) * 2 
        else qs.statement_end_offset end -    qs.statement_start_offset)/2) 
        as query_text,
    qt.dbid,
    qt.objectid 
FROM sys.dm_exec_query_stats qs
cross apply sys.dm_exec_sql_text (qs.sql_handle) as qt
ORDER BY [Avg IO] DESC



--Abfragen mit geringer PLanwiederverwendung

SELECT TOP 50
        qs.sql_handle
        ,qs.plan_handle
        ,cp.cacheobjtype
        ,cp.usecounts
        ,cp.size_in_bytes  
        ,qs.statement_start_offset
        ,qs.statement_end_offset
        ,qt.dbid
        ,qt.objectid
        ,qt.text
        ,SUBSTRING(qt.text,qs.statement_start_offset/2, 
             (case when qs.statement_end_offset = -1 
            then len(convert(nvarchar(max), qt.text)) * 2 
            else qs.statement_end_offset end -qs.statement_start_offset)/2) 
        as statement
FROM sys.dm_exec_query_stats qs
cross apply sys.dm_exec_sql_text(qs.sql_handle) as qt
inner join sys.dm_exec_cached_plans as cp on qs.plan_handle=cp.plan_handle
where cp.plan_handle=qs.plan_handle
and qt.dbid = db_id()    ----- put the database ID here
ORDER BY [Usecounts] ASC


--Statements die zu Beginn der Ausführung schlecht eingeschätzt werden können,
--können dennoch bei wiederverwendung rekompiliert werden

---- Recompilation and SQL.sql
----     (plan_generation_num) and sql statements
---- A statement has been recompiled WHEN the plan generation number is incremented
----
select top 25
    --sql_text.text,
    sql_handle,
    plan_generation_num,
    substring(text,qs.statement_start_offset/2, 
             (case when qs.statement_end_offset = -1 
            then len(convert(nvarchar(max), text)) * 2 
            else qs.statement_end_offset end - qs.statement_start_offset)/2) 
        as stmt_executing,
    execution_count,
    dbid,
    objectid 
from sys.dm_exec_query_stats as qs
    Cross apply sys.dm_exec_sql_text(sql_handle) sql_text
where plan_generation_num >1
order by sql_handle, plan_generation_num


--Row Locks

--Tabellen und Indizes mit den meisten Blocks
----Find Row lock waits
declare @dbid int
select @dbid = db_id()
Select dbid=database_id, objectname=object_name(s.object_id)
, indexname=i.name, i.index_id	--, partition_number
, row_lock_count, row_lock_wait_count
, [block %]=cast (100.0 * row_lock_wait_count / (1 + row_lock_count) as numeric(15,2))
, row_lock_wait_in_ms
, [avg row lock waits in ms]=cast (1.0 * row_lock_wait_in_ms / (1 + row_lock_wait_count) as numeric(15,2))
from sys.dm_db_index_operational_stats (@dbid, NULL, NULL, NULL) s, 	sys.indexes i
where objectproperty(s.object_id,'IsUserTable') = 1
and i.object_id = s.object_id
and i.index_id = s.index_id
order by row_lock_wait_count desc



--Herausfinden der Wartezustände

WITH Waits AS 
 ( 
 SELECT  
   wait_type,  
   wait_time_ms / 1000. AS wait_time_s, 
   100. * wait_time_ms / SUM(wait_time_ms) OVER() AS pct, 
   ROW_NUMBER() OVER(ORDER BY wait_time_ms DESC) AS rn 
 FROM sys.dm_os_wait_stats 
 WHERE wait_type  
   NOT IN 
     ('CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 
   'SLEEP_TASK', 'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 
   'CLR_AUTO_EVENT', 'CLR_MANUAL_EVENT') 
   ) -- filter out additional irrelevant waits 
    
SELECT W1.wait_type, 
 CAST(W1.wait_time_s AS DECIMAL(12, 2)) AS wait_time_s, 
 CAST(W1.pct AS DECIMAL(12, 2)) AS pct, 
 CAST(SUM(W2.pct) AS DECIMAL(12, 2)) AS running_pct 
FROM Waits AS W1 
 INNER JOIN Waits AS W2 ON W2.rn <= W1.rn 
GROUP BY W1.rn,  
 W1.wait_type,  
 W1.wait_time_s,  
 W1.pct 
HAVING SUM(W2.pct) - W1.pct < 95; -- percentage threshold;