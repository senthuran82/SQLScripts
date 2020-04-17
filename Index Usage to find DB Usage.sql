--RUN THIS TO FIND INDEX USAGE FOR ALL USER DATABASES

SELECT
DB_NAME(database_id) DatabaseName,
last_user_seek,
last_user_scan,
last_user_lookup,
last_user_update
FROM sys.dm_db_index_usage_stats
WHERE database_id > 4

----RUN THIS TO FIND DATABASES THAT DID NOT HAVE THEIR INDEXES USED

SELECT name DatabaseName
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')
EXCEPT
SELECT DISTINCT
DB_NAME(database_id) DatabaseName
FROM sys.dm_db_index_usage_stats
ORDER BY 1