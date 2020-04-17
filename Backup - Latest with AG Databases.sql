SELECT DISTINCT a.*, sd.[name]
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
AND a.database_name = d.database_name
INNER JOIN 

(SELECT sd.[name] as database_name, ag.[name] as ag_name, ags.role_desc, @@SERVERNAME AS servername--, *
FROM sys.dm_hadr_availability_replica_states ags
INNER JOIN sys.databases sd
ON sd.replica_id = ags.replica_id
INNER JOIN sys.availability_groups ag
ON ags.group_id = ag.group_id
WHERE ags.[role] = 1) agd
ON a.database_name = agd.database_name

--Missing databases in backups

--RIGHT OUTER JOIN sys.databases sd
--ON agd.database_name = sd.name
--WHERE sd.name IS NULL