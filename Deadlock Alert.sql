DBCC TRACEON (1204, -1)
DBCC TRACEON (1222, -1)


IF OBJECT_ID ('tempdb.dbo.##deadlock_error_log') IS NOT NULL
BEGIN
DROP TABLE ##deadlock_error_log
END

ELSE
BEGIN
CREATE TABLE ##deadlock_error_log
(
logid INT IDENTITY (1, 1)
,log_date DATETIME
, process_info VARCHAR (MAX)
,log_details NVARCHAR (MAX)
)

INSERT INTO ##deadlock_error_log
EXEC sp_readerrorlog

END
GO

SELECT *
FROM ##deadlock_error_log
--WHERE log_details LIKE '%deadlock encountered%'


DECLARE @logid INT
DECLARE @subject VARCHAR (200) = 'Deadlock Encountered on'+@@SERVERNAME
SELECT @logid = MAX(logid)
FROM ##deadlock_error_log
WHERE log_details LIKE '%deadlock encountered%'
--SELECT @logid


EXEC msdb.dbo.sp_send_dbmail
      @profile_name = 'SMTP',
       @recipients='',
       @subject = @subject,
       @body = 'A deadlock has been recorded.  Further information can be found in the attached file.',
       @query = 'select logDate, processInfo, errorText
from ##deadlock_error_log
where logid > ''@logid''',
      @query_result_width = 600,
      @attach_query_result_as_file = 1


SELECT *
FROM sys.dm_xe_sessions xs
    JOIN sys.dm_xe_session_targets xst
    ON xs.address = xst.event_session_address
    WHERE xs.name = 'system_health'
    AND xst.target_name = 'event_file'