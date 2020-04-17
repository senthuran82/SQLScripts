CREATE TABLE ##dv_heap_temp
(
[database_name] VARCHAR (200)
,table_name VARCHAR (200)

)

EXEC sp_MSForEachDB 'USE ?

INSERT INTO ##dv_heap_temp
SELECT DB_NAME(DB_ID()) AS [database_name], OBJECT_NAME(object_id) AS table_name
FROM sys.indexes
WHERE type_desc = ''HEAP'''

SELECT *
FROM ##dv_heap_temp
WHERE database_name NOT IN ('master', 'msdb', 'tempdb', 'model', 'reportserver', 'reportservertempdb') 

DROP TABLE ##dv_heap_temp