EXEC sp_MSForEachdb 'USE [?]
SELECT DB_NAME() AS db_name_object, OBJECT_NAME(sc.id) AS db_object_name, sc.[text], so.type_desc AS object_type, create_date, modify_date--, *
FROM syscomments sc
LEFT OUTER JOIN sys.objects so
ON sc.id = so.object_id

WHERE [text] LIKE ''%PVCLOSQL208%''
OR [text] LIKE ''%PVCLOSQL209%''
OR [text] LIKE ''%PVCLOSQL234%''
--AND is_ms_shipped = 0
'