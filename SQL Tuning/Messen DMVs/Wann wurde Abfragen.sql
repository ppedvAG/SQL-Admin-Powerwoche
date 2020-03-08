
--Letzte Leerung der Waitstats
SELECT  [wait_type] ,
        [wait_time_ms] ,
        DATEADD(SS, -[wait_time_ms] / 1000, GETDATE()) AS "Date/TimeCleared" ,
        CASE WHEN [wait_time_ms] < 1000
             THEN CAST([wait_time_ms] AS VARCHAR(15)) + ' ms'
             WHEN [wait_time_ms] BETWEEN 1000 AND 60000
             THEN CAST(( [wait_time_ms] / 1000 ) AS VARCHAR(15)) + ' seconds'
             WHEN [wait_time_ms] BETWEEN 60001 AND 3600000
             THEN CAST(( [wait_time_ms] / 60000 ) AS VARCHAR(15)) + ' minutes'
             WHEN [wait_time_ms] BETWEEN 3600001 AND 86400000
             THEN CAST(( [wait_time_ms] / 3600000 ) AS VARCHAR(15)) + ' hours'
             WHEN [wait_time_ms] > 86400000
             THEN CAST(( [wait_time_ms] / 86400000 ) AS VARCHAR(15)) + ' days'
        END AS "TimeSinceCleared"
FROM    [sys].[dm_os_wait_stats]
WHERE   [wait_type] = 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP';




/*
   check SQL Server start time - 2008 and higher
*/
SELECT  [sqlserver_start_time]
FROM    [sys].[dm_os_sys_info];


/*
   check SQL Server start time - 2005 and higher   
*/
SELECT  [create_date]
FROM    [sys].[databases]
WHERE   [database_id] = 2
GO

Create database baselinedata



USE [BaselineData];
GO

IF NOT EXISTS ( SELECT  *
                FROM    [sys].[tables]
                WHERE   [name] = N'WaitStats'
                        AND [type] = N'U' ) 
    CREATE TABLE [dbo].[WaitStats]
        (
          [RowNum] [BIGINT] IDENTITY(1, 1) ,
          [CaptureDate] [DATETIME] ,
          [WaitType] [NVARCHAR](120) ,
          [Wait_S] [DECIMAL](14, 2) ,
          [Resource_S] [DECIMAL](14, 2) ,
          [Signal_S] [DECIMAL](14, 2) ,
          [WaitCount] [BIGINT] ,
          [Percentage] [DECIMAL](4, 2) ,
          [AvgWait_S] [DECIMAL](14, 2) ,
          [AvgRes_S] [DECIMAL](14, 2) ,
          [AvgSig_S] [DECIMAL](14, 2)
        );
GO

CREATE CLUSTERED INDEX CI_WaitStats ON [dbo].[WaitStats] ([RowNum], [CaptureDate]);
GO


---Regelm‰ﬂig
USE [Baseline];
GO

INSERT  INTO dbo.WaitStats
        ( [WaitType]
         )
VALUES  ( 'Wait Statistics for ' + CAST(GETDATE() AS NVARCHAR(19))
         );

INSERT  INTO dbo.WaitStats
        ( [CaptureDate] ,
          [WaitType] ,
          [Wait_S] ,
          [Resource_S] ,
          [Signal_S] ,
          [WaitCount] ,
          [Percentage] ,
          [AvgWait_S] ,
          [AvgRes_S] ,
          [AvgSig_S] 
         )
        EXEC
            ( '
      WITH [Waits] AS
         (SELECT
            [wait_type],
            [wait_time_ms] / 1000.0 AS [WaitS],
            ([wait_time_ms] - [signal_wait_time_ms]) / 1000.0 AS [ResourceS],
            [signal_wait_time_ms] / 1000.0 AS [SignalS],
            [waiting_tasks_count] AS [WaitCount],
            100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage],
            ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [RowNum]
         FROM sys.dm_os_wait_stats
         WHERE [wait_type] NOT IN (
            N''CLR_SEMAPHORE'',   N''LAZYWRITER_SLEEP'',
            N''RESOURCE_QUEUE'',  N''SQLTRACE_BUFFER_FLUSH'',
            N''SLEEP_TASK'',      N''SLEEP_SYSTEMTASK'',
            N''WAITFOR'',         N''HADR_FILESTREAM_IOMGR_IOCOMPLETION'',
            N''CHECKPOINT_QUEUE'', N''REQUEST_FOR_DEADLOCK_SEARCH'',
            N''XE_TIMER_EVENT'',   N''XE_DISPATCHER_JOIN'',
            N''LOGMGR_QUEUE'',     N''FT_IFTS_SCHEDULER_IDLE_WAIT'',
            N''BROKER_TASK_STOP'', N''CLR_MANUAL_EVENT'',
            N''CLR_AUTO_EVENT'',   N''DISPATCHER_QUEUE_SEMAPHORE'',
            N''TRACEWRITE'',       N''XE_DISPATCHER_WAIT'',
            N''BROKER_TO_FLUSH'',  N''BROKER_EVENTHANDLER'',
            N''FT_IFTSHC_MUTEX'',  N''SQLTRACE_INCREMENTAL_FLUSH_SLEEP'',
            N''DIRTY_PAGE_POLL'')
         )
      SELECT
         GETDATE(),
         [W1].[wait_type] AS [WaitType], 
         CAST ([W1].[WaitS] AS DECIMAL(14, 2)) AS [Wait_S],
         CAST ([W1].[ResourceS] AS DECIMAL(14, 2)) AS [Resource_S],
         CAST ([W1].[SignalS] AS DECIMAL(14, 2)) AS [Signal_S],
         [W1].[WaitCount] AS [WaitCount],
         CAST ([W1].[Percentage] AS DECIMAL(4, 2)) AS [Percentage],
         CAST (([W1].[WaitS] / [W1].[WaitCount]) AS DECIMAL (14, 4)) AS [AvgWait_S],
         CAST (([W1].[ResourceS] / [W1].[WaitCount]) AS DECIMAL (14, 4)) AS [AvgRes_S],
         CAST (([W1].[SignalS] / [W1].[WaitCount]) AS DECIMAL (14, 4)) AS [AvgSig_S]
      FROM [Waits] AS [W1]
      INNER JOIN [Waits] AS [W2]
         ON [W2].[RowNum] <= [W1].[RowNum]
      GROUP BY [W1].[RowNum], [W1].[wait_type], [W1].[WaitS], 
         [W1].[ResourceS], [W1].[SignalS], [W1].[WaitCount], [W1].[Percentage]
      HAVING SUM ([W2].[Percentage]) - [W1].[Percentage] < 95;'
            );
GO

select * from tab where a=1 and b=1

------------------------

SELECT  *
FROM    [dbo].[WaitStats]
WHERE   [CaptureDate] > GETDATE() - 30
ORDER BY [RowNum];


----Auswertung

SELECT  [w].[CaptureDate] ,
        [w].[WaitType] ,
        [w].[Percentage] ,
        [w].[Wait_S] ,
        [w].[WaitCount] ,
        [w].[AvgWait_S]
FROM    [dbo].[WaitStats] w
        JOIN ( SELECT   MIN([RowNum]) AS [RowNumber] ,
                        [CaptureDate]
               FROM     [dbo].[WaitStats]
               WHERE    [CaptureDate] IS NOT NULL
                        AND [CaptureDate] > GETDATE() - 30
               GROUP BY [CaptureDate]
             ) m ON [w].[RowNum] = [m].[RowNumber]
ORDER BY [w].[CaptureDate];