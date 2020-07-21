SELECT CONF_SEQ_NO, GAS_DAY, *
FROM CFCTRL_CONF D
WHERE GAS_DAY < '12/31/2018'
AND GAS_DAY > '12/31/2017'
--ORDER BY D.CONF_SEQ_NO ASC

--28453331


EXEC sp_help 'CFCTRL_CONF'

SELECT *
FROM sys.systypes
WHERE [name] = 'QIdentifier'
--63

SELECT *
FROM sys.types
WHERE user_type_id = 63
--Create partition function based on CONF_SEQ_NO

SELECT *
FROM sys.columns
WHERE xtype = 108

CREATE PARTITION FUNCTION fn_partition_CFCTRL_CONF_CONF_SEQ_NO_2 (NUMERIC(10,0))
AS RANGE LEFT FOR VALUES (28453331)
CREATE PARTITION FUNCTION fn_partition_CFCTRL_CONF (DATETIME)
AS RANGE RIGHT FOR VALUES ('12/31/2018')

--Create the partitioning scheme

CREATE PARTITION SCHEME PartitionBySEQ_TEP_UAT_QPTM410_CONF_SEQ_NO_2
AS PARTITION fn_partition_CFCTRL_CONF_CONF_SEQ_NO_2 
TO ([PRIMARY], FG_CFCTRL_CONF, FG_CFCTRL_CONF_1)--, partition_3)
GO

--Drop the clustered index

DROP INDEX [AK_CFCTRL_CONF1] ON [dbo].[CFCTRL_CONF] 


--11:29

--Re-create unique clustered index

CREATE UNIQUE CLUSTERED INDEX [AK_CFCTRL_CONF1] ON [dbo].[CFCTRL_CONF] 
(

	[CONF_SEQ_NO] ASC,
	[TSP_NO] ASC
)WITH 
(PAD_INDEX  = ON, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) 
ON PartitionBySEQ_TEP_UAT_QPTM410_CONF_SEQ_NO_2 (CONF_SEQ_NO)
GO

SELECT *
FROM sys.partitions
WHERE OBJECT_NAME(object_id) = 'CFCTRL_CONF'