--Max workers count, Logical CPUs and Physical CPUs

SELECT
 max_workers_count
 , cpu_count
 , hyperthread_ratio
 , cpu_count/hyperthread_ratio as [physical_cpus]
FROM sys.dm_os_sys_info

--Max Worker Threads 
--<= 4 processors 64 bit 512
--Otherwise 512+((logical cpus-4)*16)


--worker thread count per cpu

SELECT scheduler_id
	,current_tasks_count
	,current_workers_count
	,active_workers_count
	,work_queue_count --tasks waiting for a worker to pick them up
	,context_switches_count
FROM sys.dm_os_schedulers
WHERE STATUS = 'Visible Online'

SELECT *
FROM sys.dm_os_workers