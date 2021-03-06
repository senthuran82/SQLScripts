https://techcommunity.microsoft.com/t5/Failover-Clustering/Tuning-Failover-Cluster-Network-Thresholds/ba-p/371834

PS command (Run PS Cmd or IDE in Admin mode as otherwise it may not let you access the cluster module)


PS C:\> (get-cluster).SameSubnetThreshold = 20

Once changed, confirm by running, Get-Cluster | Format-List -Property * to check for SameSubnetThreshold to 30

ALTER AVAILABILITY GROUP AG1 SET (FAILURE_CONDITION_LEVEL = 1);  --Failure condition levels from 1 to 5
--https://docs.microsoft.com/en-us/sql/database-engine/availability-groups/windows/configure-flexible-automatic-failover-policy?view=sql-server-ver15

ALTER AVAILABILITY GROUP AG1 SET (HEALTH_CHECK_TIMEOUT = 60000); --in milli seconds

