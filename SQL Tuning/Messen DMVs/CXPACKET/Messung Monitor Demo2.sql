DECLARE @session_id INT = 80;
SELECT  t.task_address ,
        t.task_state ,
        t.session_id ,
        t.exec_context_id ,
        wt.wait_duration_ms ,
        wt.wait_type ,
        wt.blocking_session_id ,
        wt.blocking_exec_context_id ,
        wt.resource_description ,
        t.scheduler_id
FROM    sys.dm_os_tasks t
        LEFT JOIN sys.dm_os_waiting_tasks wt ON t.task_address = wt.waiting_task_address
WHERE   t.session_id = @session_id
ORDER BY t.exec_context_id,wt.blocking_exec_context_id;