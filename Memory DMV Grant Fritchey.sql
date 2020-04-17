--Identify large consumers of memory using sys.dm_os_memory_brokers
--MEMORYBROKER_FOR_CACHE : Memory that is allocated for use by cached objects
--MEMORYBROKER_FOR_STEAL : Memory that is stolen from the buffer pool
--MEMORYBROKER_FOR_RESERVE : Memory reserved for future use by currently executing requests.
SELECT *
FROM sys.dm_os_memory_brokers

SELECT *
FROM sys.dm_os_process_memory

--Look for current committted above target committed. This indicated buffer pool using too mcuh memory
DBCC MEMORYSTATUS

--Internal memory pressure other than buffer pool. Look for page_kb for SQL clersks in type
SELECT *
FROM sys.dm_os_memory_clerks

--Look for logical reads to find the query using most memory
SELECT DB_NAME(qp.dbid) as [database_name]
, OBJECT_NAME(qp.objectid) AS [object_id]
, qt.text, qs.execution_count
, qs.last_execution_time
, qs.last_logical_reads
, qs.max_logical_reads, qs.total_logical_reads
, qp.query_plan--, *
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text (sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan (qs.plan_handle) qp