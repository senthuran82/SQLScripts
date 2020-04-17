IF OBJECT_ID ('#Test_Space') IS NULL

CREATE TABLE #Test_Space
(
name VARCHAR (200)
, rows VARCHAR (200)
, reserved VARCHAR (200)
, data VARCHAR (200)
, index_size VARCHAR (200)
, unused VARCHAR (200)
, total_space_used_in_MB DECIMAL (8, 5) 
)

DECLARE @DBName VARCHAR (200)
DECLARE @TableSchema VARCHAR (200)
DECLARE @TableName VARCHAR (200)

DECLARE space_used CURSOR
FOR
SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'

OPEN space_used
FETCH NEXT FROM space_used
INTO @DBName, @TableSchema, @TableName

WHILE @@FETCH_STATUS = 0
BEGIN

INSERT INTO #Test_Space (name, rows, reserved, data, index_size, unused)
EXEC sp_spaceused @TableName

FETCH NEXT FROM space_used
INTO @DBName, @TableSchema, @TableName

END

CLOSE space_used
DEALLOCATE space_used


UPDATE #Test_Space
SET reserved = REPLACE (reserved, ' KB', '')

UPDATE #Test_Space
SET data = REPLACE (data, ' KB', '')

UPDATE #Test_Space
SET index_size = REPLACE (index_size, ' KB', '')

UPDATE #Test_Space
SET unused = REPLACE (unused, ' KB', '')

--UPDATE #Test_Space
--SET total_space_used_in_MB = CONVERT (DECIMAL (5, 4), (CONVERT (INT, reserved)+CONVERT (INT, data)+CONVERT (INT, index_size)+CONVERT (INT, unused)))/1024

UPDATE #Test_Space
SET total_space_used_in_MB =(CONVERT (DECIMAL, data)+CONVERT (DECIMAL, index_size)+CONVERT (DECIMAL, unused))/1024.0


SELECT *
FROM #Test_Space
ORDER BY total_space_used_in_MB

DROP TABLE  #Test_Space


