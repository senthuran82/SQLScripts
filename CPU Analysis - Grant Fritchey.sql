--CPU Analysis

--Perfmon Counters
--%Processor Time
--%Privilaged time **Use with disk counters to see if processor is managing the disk much **Should be ideally around 5-10%
--Avg Processor Queue Length **Should be less than 2
--Context Switches/Sec --Rate of processor switching from one thred to another **Should be less than 5000
--Install VMware tools to see VM processor counters
--For Hyper V, use Hypervisor Logical Processor(_Total)\%

--SQL Server Statistics
--Batch Requests\Sec **10000 requests would be a busy system
--Compilations\Sec
--Recompilations\Sec

--DMVs

--sys.dm_os_wait_stats **Look for CXPACKET
--sys.dm_os_workers **Look for 'Runnable'. Too many indicate processor load
--sys.dm_os_schedulers
--sys.query_store_runtime_stats --Aggregated CPU metrics on a per query basis