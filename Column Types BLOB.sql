SELECT OBJECT_NAME (sc.object_id) AS table_name, sc.[name] AS column_name, st.[name] AS colum_type--, *
FROM sys.columns sc
INNER JOIN sys.types st
ON sc.user_type_id = st.user_type_id
INNER JOIN sys.tables stt
ON stt.object_id = sc.object_id
WHERE stt.type = 'U'
AND st.user_type_id IN (35, 165, 99, 34, 173)

SELECT *
FROM sys.types

SELECT *
FROM sys.tables