EXEC sp_configure filestream_access_level, 2
RECONFIGURE

USE [master]
GO
ALTER DATABASE Test ADD FILEGROUP [PRIMARY_FILESTREAM] CONTAINS FILESTREAM 
GO
ALTER DATABASE Test
       ADD FILE (
             NAME = N'MyDatabase_filestream_1',
             FILENAME = N'C:\SQL\SQLData\FilestreamData_1'
       )
       TO FILEGROUP [PRIMARY_FILESTREAM]
GO
USE Test
GO

CREATE TABLE images(
       id UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
       imageFile VARBINARY(MAX) FILESTREAM
);
GO

