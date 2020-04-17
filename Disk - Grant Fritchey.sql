--DISK PERFMON COUNTERS

--Physical Disk (Use for Data and Log disks)

--   Disk Transfers/Sec - Rate of read write operations on disk (IOPS Measure). 120 for sequential I/O and 100 for random I/O is typical average for magnetic disk. For SSD, it can be 5000+
--   Avg Disk Sec/Read - Time in ms for a read
--   Avg Disk Sec/Write - Needs to be beow 10 ms and even lower for TLog drives
--   Disk Bytes/Sec - Amount of data transfered to disk in read and write. Typically 1000 MB/sec and highe for SSD

--SQL Server Buffer Manager

-- Pages Read/Sec -Number of pages being read from the disk to the buffer pool
-- Pages Write/Sec -Number of pages being written from the disk to the buffer pool


--Look for io_stall_read_ms and write to see what the wait time for a file is
SELECT DB_NAME(database_id) AS [database_name], sample_ms, io_stall_read_ms, io_stall_write_ms, io_stall
FROM sys.dm_io_virtual_file_stats (DB_ID('Test'), 2)

--Look for wait count, max wait time. Consider checking WRITELOG, LOGBUFFER, ASYNC_IO_COMPLETION also in the wait_type
SELECT *
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE 'PAGELATCH%'