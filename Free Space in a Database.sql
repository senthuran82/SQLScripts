SELECT DB_NAME (dbid) AS database_name, SUM (size*.008) AS database_size_in_MB
FROM sys.sysaltfiles
WHERE DB_NAME (dbid) IS NOT NULL
GROUP BY DB_NAME (dbid)

EXEC sp_MSForEachDB 'Use [?] EXEC sp_spaceused'

EXEC sp_spaceused