USE msdb
GO

SELECT 'exec msdb..sp_update_job @job_id = '+''''+CONVERT (VARCHAR (200), job_id)+''''+', @enabled = 0'+CHAR (10)+'GO'+CHAR(10)
FROM sysjobs