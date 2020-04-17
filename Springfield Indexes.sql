SELECT OBJECT_NAME(object_id) AS table_name, [name] AS index_name, type_desc as index_type
FROM sys.indexes
WHERE OBJECT_NAME (object_id) IN ('Act_Note', 'AUDIT_LOG', 'Event_Table', 'PatientCrossWorkList', 'Plan_Item', 'Plan_Item_Order')


--Indexes to re-build

IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE [name] LIKE '%dv_index%')
DROP TABLE #dv_index_list_works

CREATE TABLE #dv_index_list_works
(
index_name VARCHAR (200)
, index_type VARCHAR (200)
)

INSERT INTO #dv_index_list_works
SELECT [name] AS index_name, type_desc as index_type
FROM sys.indexes
WHERE OBJECT_NAME (object_id) IN ('Act_Note', 'AUDIT_LOG', 'Event_Table', 'PatientCrossWorkList', 'Plan_Item', 'Plan_Item_Order')

SELECT *
FROM #dv_index_list_works

SELECT DB_NAME(database_id) AS database_name
, so.[name] AS table_name
, dmv.index_id
, si.[name]
, dmv.index_type_desc
, dmv.alloc_unit_type_desc
, dmv.index_depth
, dmv.index_level
, avg_fragmentation_in_percent
, page_count

FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED') dmv
INNER JOIN sysobjects so
ON dmv.[object_id] = so.id
INNER JOIN sys.indexes si
ON
dmv.object_id = si.object_id
AND dmv.index_id = si.index_id
INNER JOIN #dv_index_list_works temp
ON si.[name]=temp.[index_name]
WHERE dmv.avg_fragmentation_in_percent > 10
ORDER BY table_name, si.name

--Indexes to re-org

IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE [name] LIKE '%dv_index%')
DROP TABLE #dv_index_list_works

CREATE TABLE #dv_index_list_works
(
index_name VARCHAR (200)
, index_type VARCHAR (200)
)

INSERT INTO #dv_index_list_works
SELECT [name] AS index_name, type_desc as index_type
FROM sys.indexes
WHERE OBJECT_NAME (object_id) IN ('Act_Note', 'AUDIT_LOG', 'Event_Table', 'PatientCrossWorkList', 'Plan_Item', 'Plan_Item_Order')

SELECT *
FROM #dv_index_list_works

SELECT DB_NAME(database_id) AS database_name
, so.[name] AS table_name
, dmv.index_id
, si.[name]
, dmv.index_type_desc
, dmv.alloc_unit_type_desc
, dmv.index_depth
, dmv.index_level
, avg_fragmentation_in_percent
, page_count

FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED') dmv
INNER JOIN sysobjects so
ON dmv.[object_id] = so.id
INNER JOIN sys.indexes si
ON
dmv.object_id = si.object_id
AND dmv.index_id = si.index_id
INNER JOIN #dv_index_list_works temp
ON si.[name]=temp.[index_name]
WHERE dmv.avg_fragmentation_in_percent < 10
ORDER BY table_name, si.name

--Script to re-build


SELECT 'ALTER INDEX '+index_name+' REBUILD'
FROM #dv_index_list_works

--Script to re-organize

SELECT 'ALTER INDEX '+index_name+' REORGANIZE'
FROM #dv_index_list_works