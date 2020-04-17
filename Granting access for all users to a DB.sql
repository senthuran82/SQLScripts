Use master
GO

DECLARE @dbname VARCHAR(50) 
DECLARE @login VARCHAR (200)  
DECLARE @statement NVARCHAR(max)
SET @dbname = 'Test'

DECLARE db_cursor CURSOR 
LOCAL FAST_FORWARD
FOR  
SELECT [name]
FROM syslogins
WHERE [name] NOT LIKE '%##%' 
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @login  
WHILE @@FETCH_STATUS = 0  
BEGIN  

SELECT @statement = 'use '+@dbname +';'+CHAR(10)+ 'CREATE USER ['+@login+'] 
FOR LOGIN ['+@login+']'+CHAR(10)+'EXEC sp_addrolemember N''db_datareader'', ['+@login+']'+CHAR(10)+'EXEC sp_addrolemember N''db_datawriter'', ['+@login+']'+CHAR(10)

--exec sp_executesql @statement

PRINT @statement

FETCH NEXT FROM db_cursor INTO @login  
END  
CLOSE db_cursor  
DEALLOCATE db_cursor 

