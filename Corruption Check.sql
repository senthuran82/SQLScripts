SELECT DB_NAME(database_id), *
FROM msdb..suspect_pages

DBCC TRACEON (3604)
DBCC PAGE (18, 1, 24524068) WITH TABLERESULTS --Object ID 89415738
DBCC PAGE (18, 4, 2091863) --Object ID 690477559
DBCC PAGE (18, 3, 15267034)--Object ID 1306512154

SELECT OBJECT_NAME (89415738)
SELECT OBJECT_NAME (690477559)
SELECT OBJECT_NAME (1306512154)
--SELECT OBJECT_NAME (0)


--BLTRAN_INVOICE_SUB_DTL_REV
--BLRPTS_10_INVOICE_DOC_DTL
--BLTRAN_INVOICE_INPUT

DBCC CHECKTABLE (BLTRAN_INVOICE_SUB_DTL_REV) WITH ALL_ERRORMSGS

DBCC CHECKTABLE (BLRPTS_10_INVOICE_DOC_DTL) WITH ALL_ERRORMSGS

DBCC CHECKTABLE (BLTRAN_INVOICE_INPUT) WITH ALL_ERRORMSGS

--SQL Job Failure Object IDs Recorded
--89415738
--690477559
--1306512154

SELECT [name], type_desc, OBJECT_NAME(parent_object_id) AS parent_object, OBJECT_NAME(referenced_object_id) AS referenced_object
FROM sys.foreign_keys
WHERE is_ms_shipped = 0
AND OBJECT_NAME(referenced_object_id) = 'BLTRAN_INVOICE_INPUT'


-- NULL

SELECT [name], type_desc, OBJECT_NAME(parent_object_id) AS parent_object, OBJECT_NAME(referenced_object_id) AS referenced_object
FROM sys.foreign_keys
WHERE is_ms_shipped = 0
--ORDER BY OBJECT_NAME(referenced_object_id) 
AND OBJECT_NAME(referenced_object_id) = 'BLRPTS_10_INVOICE_DOC_DTL'

--NULL

SELECT [name], type_desc, OBJECT_NAME(parent_object_id) AS parent_object, OBJECT_NAME(referenced_object_id) AS referenced_object
FROM sys.foreign_keys
WHERE is_ms_shipped = 0
AND OBJECT_NAME(referenced_object_id) = 'BLTRAN_INVOICE_INPUT'

--NULL

--
