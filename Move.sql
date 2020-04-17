EXEC xp_cmdshell 'Dir C:\Test'

EXEC sp_configure 'show advanced options', 1
RECONFIGURE

EXEC sp_configure 'xp_cmdshell', 1
RECONFIGURE

CREATE TABLE #test
(
Output_1 NVARCHAR (2000)
)

INSERT INTO #test
EXEC xp_cmdshell 'Dir C:\Test'

SELECT *
FROM #test

EXEC xp_dirtree 'C:\Test', 0, 1

CREATE TABLE #file_copy
(
subdir VARCHAR (400)
, depth INT
, [file] INT
)


EXEC xp_cmdshell 'MOVE /y c:\test\*.* c:\test2'

EXEC xp_cmdshell 'Dir C:\'

EXEC xp_cmdshell 'MOVE /y D:\MSSQL12.MSSQLSERVER\MSSQL\Backup\model\Test\*.* D:\MSSQL12.MSSQLSERVER\MSSQL\Backup\TestBackupsMove'


--\\corpinfra-backup-002.abe.corp.zulily.com\backup

EXEC xp_cmdshell 'MOVE /y D:\MSSQL12.MSSQLSERVER\MSSQL\Backup\TestBackupsMove*.* \\corpinfra-backup-002.abe.corp.zulily.com\backup'
