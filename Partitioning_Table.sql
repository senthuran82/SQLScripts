USE Test
GO


CREATE TABLE partition_test_uq_clusteredindex
(
insert_date DATETIME 
, c1 INT
, c2 INT
)
GO

DECLARE @a INT = 1

WHILE @a < 1000
BEGIN
INSERT INTO partition_test
VALUES (GETDATE()-@a, @a, @a+1)
SET @a+=1
END
GO

CREATE CLUSTERED INDEX ix_partition_test
ON partition_test (insert_date)
GO

SELECT *
FROM partition_test

--TRUNCATE TABLE partition_test

ALTER DATABASE Test
ADD FILEGROUP partition_1
GO
ALTER DATABASE Test
ADD FILEGROUP partition_2
GO
ALTER DATABASE Test
ADD FILEGROUP partition_3
GO

ALTER DATABASE Test
ADD FILE
(NAME = 'partition_1_file'
, FILENAME = 'C:\SQL\partition_1.ndf'
) TO FILEGROUP partition_1

ALTER DATABASE Test
ADD FILE
(NAME = 'partition_2_file'
, FILENAME = 'C:\SQL\partition_2.ndf'
) TO FILEGROUP partition_2

ALTER DATABASE Test
ADD FILE
(NAME = 'partition_3_file'
, FILENAME = 'C:\SQL\partition_3.ndf'
) TO FILEGROUP partition_3

SELECT *
FROM sysaltfiles

--Create partitioning function

CREATE PARTITION FUNCTION fn_partition (DATETIME)
AS RANGE RIGHT FOR VALUES ('01/01/2018', '01/01/2019')
GO
--Create partitioning scheme

CREATE PARTITION SCHEME PartitionByYear
AS PARTITION fn_partition
TO (partition_1, partition_2, partition_3)
GO

--ALTER TABLE partition_test
DROP INDEX ix_partition_test ON partition_test

CREATE CLUSTERED INDEX ix_partition_test
--ON partition_test(insert_date)
ON PartitionByYear (insert_date)
--WITH DROP_EXISTING

CREATE CLUSTERED INDEX ix_partition_test ON partition_test (insert_date)
  --WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
  --      ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
  ON PartitionByYear(insert_date)

EXEC sp_help 'partition_test'

SELECT *
FROM sys.partitions
WHERE OBJECT_NAME(object_id) = 'partition_test'

--Test 2. Creating another table and splitting an existing partition into two
USE Test
GO

CREATE TABLE partition_test_split
(
insert_date DATETIME 
, c1 INT
, c2 INT
)
GO

DECLARE @a INT = 1

WHILE @a < 1000
BEGIN
INSERT INTO partition_test_split
VALUES (GETDATE()-@a, @a, @a+1)
SET @a+=1
END
GO

CREATE CLUSTERED INDEX ix_partition_test_split
ON partition_test_split (insert_date)
GO

CREATE PARTITION FUNCTION fn_partition_split (DATETIME)
AS RANGE LEFT FOR VALUES ('12/31/2017', '12/31/2018')

GO

CREATE PARTITION SCHEME PartitinByYear_split 
AS PARTITION fn_partition_split
TO (partition_1, partition_1, partition_2, partition_3) --There will be three partions created, one before 12/31/2017, another between 12/31/2017 and 12/31/2018 and the rest into 3rd FG
--The first two will go to partition_1 FG, second to partition_2 FG, and the third one remains empty and will be the the NEXT USED FG for furture partion function pslits as shown below
GO


DROP INDEX ix_partition_test_split ON partition_test_split

CREATE CLUSTERED INDEX ix_partition_test_split ON partition_test_split (insert_date)
ON PartitinByYear_split (insert_date)


SELECT *
FROM sys.partitions
WHERE OBJECT_NAME(object_id) = 'partition_test_split'

SELECT COUNT (*)
FROM partition_test_split


--Alter partion function splits the values beying '12/31/2018' into two new partition. The partition scheme already has partition_3 FG allocated and not mapped. It will be used as the NEXT_USED FG
ALTER PARTITION FUNCTION fn_partition_split ()
SPLIT RANGE ('12/31/2019')