SELECT cpu_count AS [Logical CPU Count], hyperthread_ratio AS [Hyperthread Ratio]
, cpu_count/hyperthread_ratio AS [Physical CPU Count]
,physical_memory_kb/1024 AS [Physical Memory (MB)]
FROM sys.dm_os_sys_info OPTION (RECOMPILE);

select scheduler_id, cpu_id, status, is_online 
from sys.dm_os_schedulers 
where status = 'VISIBLE ONLINE'