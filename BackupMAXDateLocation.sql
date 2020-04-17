SELECT DISTINCT a.database_name, a.backup_finish_date, a.backup_size_in_MBs, bm.physical_device_name
FROM
(SELECT
d.media_set_id
,d.database_name
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
GROUP BY d.database_name
) d
ON a.backup_finish_date = d.max_backup_finish_date
AND a.database_name = d.database_name
INNER JOIN msdb.dbo.backupmediafamily bm
ON bm.media_set_id = a.media_set_id

--Same query but with only disk backups included (device_type =2 and <> 7)

SELECT DISTINCT a.database_name, a.backup_finish_date, a.backup_size_in_MBs, a.device_type,  bm.physical_device_name
FROM
(SELECT
a.device_type
,d.media_set_id
,d.database_name
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
AND a.device_type = 2
GROUP BY d.database_name
) d
ON a.backup_finish_date = d.max_backup_finish_date
AND a.database_name = d.database_name
INNER JOIN msdb.dbo.backupmediafamily bm
ON bm.media_set_id = a.media_set_id
WHERE a.device_type <> 7
