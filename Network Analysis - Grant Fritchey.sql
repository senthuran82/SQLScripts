--Network

--Perfmon

--Install Network Monitor Driver to collect perfmon data. can be installed from local area connection propertes from network adapter

--Network Interface Bytes Total/Sec - A high value indicates successful transmissison
--Network Segment - % Net Utilization - Avg value < 80% of network bandwidth
--Use Network Interface\Current Bandwidth to find out the bandwidth **%net utilization should be around or less than 50% of bandwidth to allow for spikes

--DMVs

--sys.dm_os_wait_stats - Look for ASYNC_NETWORK_IO **Mostly due to porr query performance rather than network

--Use SPs so request becomes one, instead of many lines of code, especailly for Azure

--SET NOCOUNT ON is a good way to avoid a not so used result set

--OTHER METRICS

--Perfmon

--SQL Server: Access Methods Full Scans/Sec
--SQL Server: Latches Total Latch Wait Time (ms)
--Lock Timouts\Sec
--Lock Wait Time (ms) **Zero value of timeouts\sec and high value of wait time (ms) indicates blocking    



