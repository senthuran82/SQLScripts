SELECT sd.[name]
, sd.state_desc AS database_status
, f.backup_finish_date AS last_full_backup_date
, d.backup_finish_date AS last_diff_backup_date
, CASE WHEN (sd.database_id < 4 OR sd.recovery_model = 3) THEN 'N/A' 
ELSE CONVERT (VARCHAR (20), l.backup_finish_date, 120 ) END AS last_log_backup_date
, CASE WHEN (f.backup_finish_date < (DATEADD (DAY, -7, GETDATE())) OR (f.backup_finish_date IS NULL)) THEN 'No full backup in the last seven days' END AS [missing recent backup]
FROM sys.databases sd
LEFT OUTER JOIN
(SELECT DISTINCT a.*
FROM
(SELECT
d.database_name
,d.backup_finish_date
,(backup_size/1024/1024) AS backup_size_in_MBs
FROM msdb.dbo.backupmediafamily a
INNER JOIN msdb.dbo.backupset d
ON a.media_set_id = d.media_set_id) a
INNER JOIN
(SELECT
 d.database_name
,MAX(d.backup_finish_date) AS max_backup_finish_date
FROM msdb.dbo.backupmediafamily a
INNER JOIN msdb.dbo.backupset d
ON a.media_set_id = d.media_set_id
WHERE [type] = 'D'
GROUP BY d.database_name) d
ON a.backup_finish_date = d.max_backup_finish_date
AND a.database_name = d.database_name ) f
ON sd.[name] = f.database_name
LEFT OUTER JOIN
(SELECT DISTINCT a.*
FROM
(SELECT
d.database_name
,d.backup_finish_date
,(backup_size/1024/1024) AS backup_size_in_MBs
FROM msdb.dbo.backupmediafamily a
INNER JOIN msdb.dbo.backupset d
ON a.media_set_id = d.media_set_id) a
INNER JOIN
(SELECT
 d.database_name
,MAX(d.backup_finish_date) AS max_backup_finish_date
FROM msdb.dbo.backupmediafamily a
INNER JOIN msdb.dbo.backupset d
ON a.media_set_id = d.media_set_id
WHERE [type] = 'I'
GROUP BY d.database_name) d
ON a.backup_finish_date = d.max_backup_finish_date
AND a.database_name = d.database_name 
) d
ON sd.[name] = d.database_name
LEFT OUTER JOIN
(SELECT DISTINCT a.*
FROM
(SELECT
d.database_name
,d.backup_finish_date
,(backup_size/1024/1024) AS backup_size_in_MBs
FROM msdb.dbo.backupmediafamily a
INNER JOIN msdb.dbo.backupset d
ON a.media_set_id = d.media_set_id) a
INNER JOIN
(SELECT
 d.database_name
,MAX(d.backup_finish_date) AS max_backup_finish_date
FROM msdb.dbo.backupmediafamily a
INNER JOIN msdb.dbo.backupset d
ON a.media_set_id = d.media_set_id
WHERE [type] = 'L'
GROUP BY d.database_name) d
ON a.backup_finish_date = d.max_backup_finish_date
AND a.database_name = d.database_name 
) l
on sd.[name] = l.database_name