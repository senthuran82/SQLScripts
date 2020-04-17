SELECT sd.[name] AS database_name, ag.[name] AS ag_name, ags.role_desc, @@SERVERNAME AS servername--, *
FROM sys.dm_hadr_availability_replica_states ags
INNER JOIN sys.databases sd
ON sd.replica_id = ags.replica_id
INNER JOIN sys.availability_groups ag
ON ags.group_id = ag.group_id
WHERE ags.[role] = 1