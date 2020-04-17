USE AdminDB
GO
--DECLARE @ag_name VARCHAR (200)
--SET @ag_name = 'AdminDB'

CREATE FUNCTION Is_AG_Primary (@ag_name VARCHAR (200))
RETURNS INT
AS
BEGIN
DECLARE @is_primary INT
IF EXISTS (SELECT ags.[role]--, ags.role_desc, ags.is_local, ags.role--, operational_state_desc, ag.name, ar.replica_server_name, ags.role_desc
FROM sys.dm_hadr_availability_replica_states ags
INNER JOIN sys.availability_groups ag
ON ags.group_id = ag.group_id
WHERE [name] = @ag_name
AND ags.[role] = 1)
SET @is_primary = 1
ELSE
SET @is_primary = 0
RETURN (@is_primary)
END
