SELECT OBJECT_NAME (object_id, database_id) AS stored_proc_name, s.execution_count, CONVERT (DECIMAL (20, 2), (total_elapsed_time)/1000000) total_elapsed_time_in_secs, CONVERT (DECIMAL (20, 2), (last_elapsed_time/1000000)) last_elapsed_time_in_secs, CONVERT (DECIMAL (20, 2), (min_elapsed_time/1000000)) min_elapsed_time_in_secs, CONVERT (DECIMAL (20, 2), (max_elapsed_time/1000000)) max_elapsed_time_in_secs, CONVERT (DECIMAL (20, 2), (((total_elapsed_time/execution_count)/1000000))) AS avg_elapsed_time_in_secs
FROM sys.dm_exec_procedure_stats s
CROSS APPLY sys.dm_exec_sql_text (s.sql_handle) s1
WHERE database_id = 7
AND [type] = 'P'