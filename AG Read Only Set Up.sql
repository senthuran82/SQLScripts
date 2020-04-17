ALTER AVAILABILITY GROUP [AG40VS]
 
 MODIFY REPLICA ON
 
N'DB41VS' WITH
 
(SECONDARY_ROLE (ALLOW_CONNECTIONS = READ_ONLY));
 
ALTER AVAILABILITY GROUP [AG40VS]
 
 MODIFY REPLICA ON
 
N'DB41VS' WITH
 
(SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'TCP://DB41VS.test.com:50000'));
 
 
 
ALTER AVAILABILITY GROUP [AG40VS]
 
 MODIFY REPLICA ON
 
N'DB42VS' WITH
 
(SECONDARY_ROLE (ALLOW_CONNECTIONS = READ_ONLY));
 
ALTER AVAILABILITY GROUP [AG40VS]
 
 MODIFY REPLICA ON
 
N'DB42VS' WITH
 
(SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'TCP://DB42VS.test.com:50000'));
 
 
 
ALTER AVAILABILITY GROUP [AG40VS]
 
 MODIFY REPLICA ON
 
N'DB43VS' WITH
 
(SECONDARY_ROLE (ALLOW_CONNECTIONS = READ_ONLY));
 
ALTER AVAILABILITY GROUP [AG40VS]
 
 MODIFY REPLICA ON
 
N'DB43VS' WITH
 
(SECONDARY_ROLE (READ_ONLY_ROUTING_URL = N'TCP:// N'DB43VS'.test.com:50000'));
 


--Read only routing list

ALTER AVAILABILITY GROUP [AG40VS]
 
MODIFY REPLICA ON
 
N'DB41VS' WITH
 
(PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('DB42VS','DB43VS')));
 
 
 
ALTER AVAILABILITY GROUP [AG40VS]
 
MODIFY REPLICA ON
 
N'DB42VS' WITH
 
(PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('DB43VS','DB41VS')));
 
 
 
ALTER AVAILABILITY GROUP [AG40VS]
 
MODIFY REPLICA ON
 
N'DB43VS' WITH
 
(PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=('DB42VS','DB41VS')));
 

 --Checking for configurations

  
SELECT	  AVGSrc.replica_server_name AS SourceReplica		
		, AVGRepl.replica_server_name AS ReadOnlyReplica
		, AVGRepl.read_only_routing_url AS RoutingURL
		, AVGRL.routing_priority AS RoutingPriority
FROM sys.availability_read_only_routing_lists AVGRL
INNER JOIN sys.availability_replicas AVGSrc ON AVGRL.replica_id = AVGSrc.replica_id
INNER JOIN sys.availability_replicas AVGRepl ON AVGRL.read_only_replica_id = AVGRepl.replica_id
INNER JOIN sys.availability_groups AV ON AV.group_id = AVGSrc.group_id
ORDER BY SourceReplica

--Connection string

--Server= tcp:AG40VS,50000; Database=test; IntegratedSecurity=SSPI; MultiSubnetFailover=True; ApplicationIntent=ReadOnly;

--Load balance

ALTER AVAILABILITY GROUP AG40VS MODIFY REPLICA 
ON N'DB41VS'
WITH (PRIMARY_ROLE (READ_ONLY_ROUTING_LIST=(('DB42VS', 'DB43VS'), 'DB41VS')));
 
