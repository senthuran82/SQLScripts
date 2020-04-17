ALTER AVAILABILITY GROUP AG1 SET (FAILURE_CONDITION_LEVEL = 1);  --Failure condition levels from 1 to 5
--https://docs.microsoft.com/en-us/sql/database-engine/availability-groups/windows/configure-flexible-automatic-failover-policy?view=sql-server-ver15

ALTER AVAILABILITY GROUP AG1 SET (HEALTH_CHECK_TIMEOUT = 60000); --in milli seconds