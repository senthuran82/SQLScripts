DECLARE @backup_since DATETIME = DATEADD (WEEK, -2, GETDATE())

SELECT DISTINCT a.*, d.backup_type
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
,d.backup_finish_date AS backup_finish_date
,CASE d.[type] 
	WHEN 'D' THEN 'Full Backup' 
	WHEN 'L' THEN 'Log Backup'
	WHEN 'I' THEN 'DIfferential Backup'
	ELSE 'Unknown' END AS backup_type
FROM msdb.dbo.backupmediafamily a
INNER JOIN msdb.dbo.backupset d
ON a.media_set_id = d.media_set_id
--WHERE [type] = 'L'
--GROUP BY d.database_name
WHERE d.backup_finish_date > @backup_since
) d
ON a.backup_finish_date = d.backup_finish_date
AND a.database_name = d.database_name
ORDER BY a.database_name ASC, a.backup_finish_date DESC