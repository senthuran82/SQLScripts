SELECT *
FROM 

(SELECT [name], [recovery_model_desc]
FROM sys.databases
WHERE [recovery_model_Desc] = 'FULL') a

FULL OUTER JOIN 


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
AND a.database_name = d.database_name) d
ON a.[name] = d.database_name