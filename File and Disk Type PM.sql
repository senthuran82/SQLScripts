SELECT 
DB_NAME(dbid) AS database_name
, CASE WHEN [dbid] < 5 THEN 'System' ELSE 'User' END AS [database_type]
, [filename]
, CASE WHEN SUBSTRING (REVERSE ([filename]), 1, 3) = 'fdl' THEN 'Log File' WHEN SUBSTRING (REVERSE ([filename]), 1, 3) = 'fdm' THEN 'Primary Data File' WHEN SUBSTRING (REVERSE ([filename]), 1, 3) = 'fdn' THEN 'Secondary Data File' END AS [file_type]
, CASE WHEN SUBSTRING ([filename], 1, 1) = 'E' THEN 'Data' WHEN SUBSTRING ([filename], 1, 1) = 'F' THEN 'Log' ELSE 'System' END AS 'disk_type'
FROM sysaltfiles
