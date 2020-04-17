SELECT sj.[name],  MAX (sjh.run_date) AS last_run_date --sjs.next_run_date,
FROM sysjobs sj
INNER JOIN sysjobschedules sjs
ON sj.job_id = sjs.job_id
INNER JOIN (SELECT DISTINCT job_id, run_date
FROM sysjobhistory) sjh
ON sj.job_id = sjh.job_id
WHERE [name] LIKE '%index%'
OR [name] LIKE '%reorg%'
OR [name] LIKE '%maintenance%'
AND sj.enabled = 1
GROUP BY sj.[name]--, sjs.next_run_date
ORDER BY sj.[name]