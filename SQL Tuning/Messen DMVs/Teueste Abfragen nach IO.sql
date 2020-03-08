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
