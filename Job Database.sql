SELECT sj.name, sjs.database_name, CASE sj.enabled WHEN 1 THEN 'Enabled' ELSE 'Disabled' END AS job_status
FROM msdb..sysjobs sj
INNER JOIN msdb..sysjobsteps sjs
ON sj.job_id = sjs.job_id

SELECT *
FROM msdb..sysjobsteps