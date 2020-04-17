USE AdminDB
GO
CREATE FUNCTION udf_AGPrimaryCheck
(@availability_group sysname)
RETURNS INT
AS
BEGIN
IF EXISTS 
(
SELECT TOP 10 ag.name, ar.role, ar.is_local
FROM sys.dm_hadr_availability_replica_states ar
INNER JOIN sys.availability_groups ag
ON ar.group_id = ag.group_id
AND ag.[name] = @availability_group
AND ar.[role] = 1
AND ar.is_local = 1
) 

RETURN 1

RETURN 0

END


SELECT dbo.udf_AGPrimaryCheck ('SolarWindsOrion')

--http://dba.stackexchange.com/questions/45137/sql-server-agent-jobs-and-availability-groups

--Test Job

IF admindb.dbo.udf_AGPrimaryCheck ('SolarWindsOrion') = 1
SELECT 1
ELSE 
RAISERROR ('Not the primary replica', 2, 1)