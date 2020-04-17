--SELECT DB_NAME(istat.database_id) AS database_name, so.[name], si.[name] AS index_name, istat.last_user_lookup, istat.last_user_scan, istat.last_user_seek, istat.user_updates
--FROM sys.dm_db_index_usage_stats istat
--INNER JOIN sys.objects so
--ON istat.object_id = so.object_id
--LEFT OUTER JOIN sysindexes si
--ON istat.index_id = si.id


EXEC sp_MSForEachDB 
' USE ?

SELECT DB_NAME(database_id) AS [DB Name]
, OBJECT_NAME (dm.object_id) AS [Table Name]
, si.[name]
, user_seeks AS [User Seeks]
, user_scans AS [User Scans]
, user_lookups AS [User Lookups]
, user_updates AS [User Updates]
, last_user_seek AS [Last User Seek]
, last_user_scan AS [Last User Scan]
, last_user_lookup AS [Last User Lookup]
, last_user_update AS [Last User Update]
--, *
FROM sys.dm_db_index_usage_stats dm
INNER JOIN sys.indexes si
ON si.index_id = dm.index_id
AND dm.object_id = si.object_id
INNER JOIN sysobjects so
ON so.id = si.object_id
WHERE dm.database_id = DB_ID()
AND si.name IS NOT NULL
AND OBJECTPROPERTY (dm.object_id, ''IsUserTable'') = 1
AND database_id > 4
ORDER BY COALESCE (last_user_seek, last_user_scan, last_user_lookup, last_user_update)
'

--Index seek and last table modified date

SELECT DB_NAME(database_id) AS [DB Name]
, OBJECT_NAME (dm.object_id) AS [Table Name]
, si.[name]
, user_seeks AS [User Seeks]
, user_scans AS [User Scans]
, user_lookups AS [User Lookups]
, user_updates AS [User Updates]
, last_user_seek AS [Last User Seek]
, last_user_scan AS [Last User Scan]
, last_user_lookup AS [Last User Lookup]
, last_user_update AS [Last User Update]
, so.modify_date
, user_updates-user_seeks AS [update and seek difference]
FROM sys.dm_db_index_usage_stats dm
INNER JOIN sys.indexes si
ON si.index_id = dm.index_id
AND dm.object_id = si.object_id
INNER JOIN sys.objects so
ON so.object_id = si.object_id
WHERE dm.database_id = DB_ID()
AND si.name IS NOT NULL
AND OBJECTPROPERTY (dm.object_id, 'IsUserTable') = 1
AND database_id > 4
ORDER BY COALESCE (last_user_seek, last_user_scan, last_user_lookup, last_user_update)