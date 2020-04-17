--SELECT sa.*, si.cpu_count as logical_processors, CASE WHEN si.cpu_count > sa.file_count  THEN 'Need to add more files' WHEN si.cpu_count < sa.file_count THEN 'consider reducing the number of files to 8'ELSE 'Files are configured correctly' END AS 'action'
--FROM

--(
--SELECT @@SERVERNAME AS server_name,  CASE groupid WHEN 0 THEN 'Temp_Log' ELSE 'Temp_Data' END AS 'file_type', COUNT (*) AS file_count, filename
--FROM sysaltfiles
--WHERE [dbid] = 2
--AND groupid = 1
--GROUP BY [groupid], filename
--) sa, sys.dm_os_sys_info si


SELECT sf.server_name
, sf.filename
, sc.file_type
, sc.file_count
, si.cpu_count
, sf.initial_size_in_MBs
, sf.growth_in_MBs
, CASE sf.initial_size_in_MBs%8 
       WHEN 0 THEN 'Files size in mutiples of 8' 
	   ELSE 'File size is not a multiple of 8' 
	   END AS file_size_config
, CASE WHEN si.cpu_count > sc.file_count  
       THEN 'Need to add more files' 
	   WHEN si.cpu_count < sc.file_count 
	   THEN 'consider reducing the number of files to 8' 
	   ELSE 'Files are configured correctly' 
	   END AS 'action'
FROM

(
SELECT @@SERVERNAME AS server_name, filename, size*8/1024 AS [initial_size_in_MBs], growth*8/1024 AS [growth_in_MBs]
FROM sysaltfiles
WHERE dbid = 2
AND groupid = 1
) sf
INNER JOIN
(
SELECT @@SERVERNAME AS server_name,  CASE groupid WHEN 0 THEN 'Temp_Log' ELSE 'Temp_Data' END AS 'file_type', COUNT (*) AS file_count--, filename
FROM sysaltfiles
WHERE [dbid] = 2
AND groupid = 1
GROUP BY [groupid]
) sc
ON sf.server_name = sc.server_name
, sys.dm_os_sys_info si



