SELECT DISTINCT a.database_name, 'Full' AS backup_type, a.backup_finish_date, a.backup_size_in_MBs, bm.physical_device_name
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
,d.backup_finish_date
FROM msdb.dbo.backupmediafamily a
INNER JOIN msdb.dbo.backupset d
ON a.media_set_id = d.media_set_id
WHERE [type] = 'D'
AND d.backup_finish_date > DATEADD (wk, -1, GETDATE())
--GROUP BY d.database_name
) d
ON a.backup_finish_date = d.backup_finish_date
AND a.database_name = d.database_name
INNER JOIN msdb.dbo.backupmediafamily bm
ON bm.media_set_id = a.media_set_id