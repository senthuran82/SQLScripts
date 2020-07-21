ALTER DATABASE Sales
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE

ALTER DATABASE Sales
SET OFFLINE

SELECT *
FROM sysaltfiles

--rename physical file on the disk to the new name, in this case Spri1dat.mdf was renamed to SPri1dat_new.mdf

ALTER DATABASE Sales
MODIFY FILE (Name = 'SPri1_dat', FILENAME = 'C:\SQL\SPri1dat_new.mdf')

ALTER DATABASE Sales
SET ONLINE

SELECT *
FROM sysaltfiles