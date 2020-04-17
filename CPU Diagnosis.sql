SELECT *
FROM sys.dm_os_sys_info

select spid,[blocked],status,db_name(s.dbid)DBNAME,SUBSTRING (qt.text,s.stmt_start/2,
         (CASE WHEN s.stmt_end = -1
            THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
          ELSE s.stmt_end END - s.stmt_start)/2) AS indivudual_query,cpu,[waittime],login_time,physical_io,hostname
          [lastwaittype],o.name,loginame,PROGRAM_NAME
 from master..sysprocesses s
cross apply sys.dm_exec_sql_text(s.sql_handle) qt
LEFT OUTER JOIN sys.objects o ON qt.objectid = o.object_id
where status not in ('sleeping','dormant','background') and spid<>@@SPID
order by login_time,cpu desc
go

DECLARE @ms_ticks_now BIGINT

SELECT @ms_ticks_now = ms_ticks
FROM sys.dm_os_sys_info;

SELECT TOP 15 record_id
	,dateadd(ms, - 1 * (@ms_ticks_now - [timestamp]), GetDate()) AS EventTime
	,SQLProcessUtilization
	,SystemIdle
	,100 - SystemIdle - SQLProcessUtilization AS OtherProcessUtilization
FROM (
	SELECT record.value('(./Record/@id)[1]', 'int') AS record_id
		,record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS SystemIdle
		,record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS SQLProcessUtilization
		,TIMESTAMP
	FROM (
		SELECT TIMESTAMP
			,convert(XML, record) AS record
		FROM sys.dm_os_ring_buffers
		WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
			AND record LIKE '%<SystemHealth>%'
		) AS x
	) AS y
ORDER BY record_id DESC

SELECT *
FROM sys.dm_os_ring_buffers

SELECT DB_NAME (dr.database_id) AS database_name
, SUSER_SNAME(dr.user_id) AS user_name
, dr.wait_type AS wait_type
, dt.text AS sql_full_text
,SUBSTRING(dt.TEXT, statement_start_offset / 2 + 1, (
			(
				CASE 
					WHEN dr.statement_end_offset = - 1
						THEN (LEN(CONVERT(NVARCHAR(max), dt.TEXT)) * 2)
					ELSE dr.statement_end_offset
					END
				) - dr.statement_start_offset
			) / 2 + 1) AS sql_text
, dr.cpu_time/1000 AS cpu_time_in_seconds
, dr.percent_complete
, dr.row_count
, dp.query_plan
, *
FROM sys.dm_exec_requests dr
CROSS APPLY sys.dm_exec_sql_text (dr.sql_handle) dt
CROSS APPLY sys.dm_exec_query_plan (dr.plan_handle) dp

--SELECT *
--FROM sys.dm_exec_sql_text

SELECT *
FROM sys.dm_os_sys_info

 DECLARE @ts_now BIGINT
   SELECT @ts_now = cpu_ticks / CONVERT(FLOAT, cpu_ticks) FROM sys.dm_os_sys_info
   
   SELECT record_id,
      DATEADD(ms, -1 * (@ts_now - [timestamp]), GETDATE()) AS EventTime, 
      SQLProcessUtilization,
      SystemIdle,
      100 - SystemIdle - SQLProcessUtilization AS OtherProcessUtilization
   FROM (
      SELECT 
         record.value('(./Record/@id)[1]', 'int') AS record_id,
         record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS SystemIdle,
         record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS SQLProcessUtilization,
         TIMESTAMP
      FROM (
         SELECT TIMESTAMP, CONVERT(XML, record) AS record 
         FROM sys.dm_os_ring_buffers 
         WHERE ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
         AND record LIKE '% %') AS x
      ) AS y 
   ORDER BY record_id DESC