SELECT [text], CachedPlans.size_in_bytes, CachedPlans.plan_handle, CachedPlans.objtype, CachedPlans.usecounts
FROM sys.dm_exec_cached_plans AS CachedPlans
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE CachedPlans.cacheobjtype = N'Compiled Plan'

SELECT *
FROM sys.dm_os_wait_stats

DBCC SQLPERF (N'sys.dm_os_wait_stats', CLEAR);
GO