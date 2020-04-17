SELECT sd.[name], ags.role_desc, @@SERVERNAME
FROM sys.dm_hadr_availability_replica_states ags
INNER JOIN sys.databases sd
ON sd.replica_id = ags.replica_id
WHERE ags.[role] = 1

--DECLARE @ServerName VARCHAR (20)
--SELECT @ServerName = @@SERVERNAME

--IF (@ServerName = 'TWASYNCDB1')
--	BEGIN
--	    DECLARE @sql VARCHAR (MAX)
--		SET @sql = 'ALTER DATABASE '+ drs.database_name+' SET HADR SUSPEND'+CHAR (10)+'GO'+CHAR(10)--, ags.name
--		FROM sys.dm_hadr_database_replica_cluster_states drs
--		INNER JOIN sys.dm_hadr_database_replica_states rs
--		ON rs.group_database_id = drs.group_database_id
--		INNER JOIN sys.availability_groups ags
--		ON rs.group_id = ags.group_id
--		WHERE ags.name = 'TWAG'
--		PRINT @sql
--	END
--	ELSE 
--		BEGIN
--		SELECT 1/0
--	END


DECLARE @ServerName VARCHAR (20)
SELECT @ServerName = @@SERVERNAME

IF (@ServerName = 'SQLAAG-01')
	BEGIN
	    DECLARE @sql VARCHAR (MAX)
		SELECT DISTINCT 'ALTER DATABASE '+ drs.database_name+' SET HADR SUSPEND'+CHAR (10)+'GO'+CHAR(10)--, ags.name
		FROM sys.dm_hadr_database_replica_cluster_states drs
		INNER JOIN sys.dm_hadr_database_replica_states rs
		ON rs.group_database_id = drs.group_database_id
		INNER JOIN sys.availability_groups ags
		ON rs.group_id = ags.group_id
		WHERE ags.name = 'SQLAAG-CLU-AG'
		--PRINT @sql
	END
	ELSE 
		BEGIN
		SELECT 1/0
	END