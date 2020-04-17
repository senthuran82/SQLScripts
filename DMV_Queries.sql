/*******sp_who 2*******/

EXEC sp_who2 ACTIVE

/**********Identify the blocking SQL**************/

SELECT
  session_id
, blocking_session_id
, st.text AS blocked_sql
, st2.text AS blocking_sql
FROM sys.dm_exec_requests dmer
CROSS APPLY sys.dm_exec_sql_text (dmer.sql_handle) st
INNER JOIN sys.sysprocesses sp
ON dmer.blocking_session_id = sp.spid
CROSS APPLY sys.dm_exec_sql_text (sp.sql_handle) st2

/******Finding out the fragmentation count of indexes. Idnetifies all indexes with a fragmentation count greater than 15%. Look for a fragmenation count greater than 40% for severe impact*************/

SELECT DB_NAME(database_id) AS database_name
, so.[name] AS table_name
, dmv.index_id
, si.[name]
, dmv.index_type_desc
, dmv.alloc_unit_type_desc
, dmv.index_depth
, dmv.index_level
, avg_fragmentation_in_percent
, page_count

FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED') dmv
INNER JOIN sysobjects so
ON dmv.[object_id] = so.id
INNER JOIN sys.indexes si
ON
dmv.object_id = si.object_id
AND dmv.index_id = si.index_id
WHERE dmv.avg_fragmentation_in_percent > 15
ORDER BY table_name, si.name

/*****Finding out when the statistics were updated last. If too many statistics have an uodate date that is too long ago then we might have a problem with execution plans where they are not computed right********/\

SELECT OBJECT_NAME(object_id) AS [ObjectName]
      ,[name] AS [StatisticName]
      ,STATS_DATE([object_id], [stats_id]) AS [StatisticUpdateDate]
FROM sys.stats

/******Misisng indexes. This will return an extensive list and should be implemented as is. It needs further review of its results***********/

DECLARE @runtime datetime
SELECT CONVERT (varchar, @runtime, 126) AS runtime, mig.index_group_handle, mid.index_handle,
CONVERT (decimal (28,1), migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans)) AS improvement_measure,
'CREATE INDEX missing_index_' + CONVERT (varchar, mig.index_group_handle) + '_' +
CONVERT (varchar, mid.index_handle)
+ ' ON ' + mid.statement
+ ' (' + ISNULL (mid.equality_columns,'')
+ CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT
NULL THEN ',' ELSE '' END + ISNULL (mid.inequality_columns, '')
+ ')'
+ ISNULL (' INCLUDE (' + mid.included_columns + ')', '') AS
create_index_statement,
migs.*, mid.database_id, mid.[object_id]
FROM sys.dm_db_missing_index_groups mig
INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle =
mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle =
mid.index_handle
WHERE CONVERT (decimal (28,1), migs.avg_total_user_cost * migs.avg_user_impact *
(migs.user_seeks + migs.user_scans)) > 10
ORDER BY migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks +
migs.user_scans) DESC
PRINT ''
GO

