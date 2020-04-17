--SELECT *
--FROM INFORMATION_SCHEMA.TABLES


--SELECT *
--FROM sys.objects
--WHERE [type] = 'U'
--AND is_ms_shipped = 0

DECLARE @table VARCHAR (200)
DECLARE @sql VARCHAR (MAX)
DECLARE fetch_table CURSOR FORWARD_ONLY
FOR
SELECT [name]
FROM sys.objects
WHERE [type] = 'U'
AND is_ms_shipped = 0

OPEN fetch_table
FETCH NEXT FROM fetch_table INTO @table

nextone:
WHILE @@FETCH_STATUS = 0
BEGIN

BEGIN TRY

PRINT 'try'+' '+@table
SET @sql = 'SELECT * FROM '+@table+' INTO '+@table+'_Copy'
RAISERROR ('Test', 11, 0);
--PRINT @sql

FETCH NEXT FROM fetch_table
INTO @table

END TRY

BEGIN CATCH

PRINT 'catch '+ @table
FETCH NEXT FROM fetch_table
INTO @table
GOTO nextone
END CATCH

END

CLOSE fetch_table
DEALLOCATE fetch_table