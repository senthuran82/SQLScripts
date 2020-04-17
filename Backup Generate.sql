DECLARE @location VARCHAR (200) = 'C:\SQL Server'

SELECT 'BACKUP DATABASE '+[name]+' TO DISK = '+''''+@location+'\'+[name]+'.BAK'+''''+CHAR(10)+'GO'+CHAR(10)
FROM sys.databases
WHERE database_id > 4
