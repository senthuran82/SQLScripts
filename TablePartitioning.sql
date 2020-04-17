USE Test

GO

ALTER DATABASE Test
ADD FILEGROUP Partition_Test

GO

ALTER DATABASE Test
ADD FILEGROUP Partition_Test_1

GO

ALTER DATABASE Test
ADD FILEGROUP Partition_Test_2

GO

ALTER DATABASE Test
ADD FILEGROUP Partition_Test_3

GO


ALTER DATABASE Test
ADD FILE
(
NAME = Partition_Test_File
, FILENAME =  'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Partition_Test_File.ndf'
, SIZE = 100MB
, FILEGROWTH = 10MB
)

GO

ALTER DATABASE Test
ADD FILE
(
NAME = Partition_Test_File_1
, FILENAME =  'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Partition_Test_File_1.ndf'
, SIZE = 100MB
, FILEGROWTH = 10MB
)

GO

ALTER DATABASE Test
ADD FILE
(
NAME = Partition_Test_File_2
, FILENAME =  'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Partition_Test_File_2.ndf'
, SIZE = 100MB
, FILEGROWTH = 10MB
)

GO

ALTER DATABASE Test
ADD FILE
(
NAME = Partition_Test_File_3
, FILENAME =  'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Partition_Test_File_3.ndf'
, SIZE = 100MB
, FILEGROWTH = 10MB
)

GO

CREATE PARTITION FUNCTION PartitionTest_fn (int)
AS RANGE LEFT FOR VALUES (1, 10, 20)

GO

CREATE PARTITION SCHEME PartitionScheme
AS PARTITION PartitionTest_fn
TO (Partition_Test, Partition_Test_1, Partition_Test_2, Partition_Test_3)

GO

CREATE TABLE partition_test_table
(
c1 INT
,c2 INT
)
ON PartitionScheme (c1)

