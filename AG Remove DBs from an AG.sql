SELECT  'ALTER AVAILABILITY GROUP '+ag.[name]+' REMOVE DATABASE '+sd.[name]+CHAR(10)+'GO'+CHAR(10)
FROM sys.dm_hadr_availability_replica_states ags
INNER JOIN sys.databases sd
ON sd.replica_id = ags.replica_id
INNER JOIN sys.availability_groups ag
ON ags.group_id = ag.group_id
WHERE ags.[role] = 1
AND ag.[name]= 'AG_GP'