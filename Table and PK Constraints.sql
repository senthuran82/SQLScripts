SELECT DISTINCT
st.name
, SUM (total_pages)*8.0/1024.0 AS [Size in MB]
, sc.table_name
, sc.constraint_name
FROM sys.partitions sp
INNER JOIN sys.tables st
ON sp.object_id = st.object_id
INNER JOIN sys.allocation_units sa
ON sp.partition_id = sa.container_id
INNER JOIN (SELECT CONSTRAINT_NAME
, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'
) sc
ON sc.table_name = st.name
GROUP BY st.name, sc.table_name, sc.constraint_name
ORDER BY [Size in MB] DESC 