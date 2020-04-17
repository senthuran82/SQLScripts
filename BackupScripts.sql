BACKUP DATABASE TestRepl
TO DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.BAK'
WITH STATS = 10

BACKUP DATABASE TestRepl
TO DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.DIFF'
WITH DIFFERENTIAL 
,STATS = 10

CREATE TABLE TestRepl3
(
c1 INT PRIMARY KEY CLUSTERED
, c2 INT
) ON SECONDARY

BACKUP LOG TestRepl
TO DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.TRN'

RESTORE FILELISTONLY
FROM DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.BAK'

--restore with standby
RESTORE DATABASE TestRepl2
FROM DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.BAK'
WITH
MOVE 'TestRepl' TO 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.mdf'
, MOVE 'TestReplSecondary' TO 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestReplSecondary.ndf'
, MOVE 'TestRepl_log' TO 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl_log.ldf'
, STANDBY = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl2Standby.BAK'
, STATS = 10

--restore with standby using the same standby file
RESTORE DATABASE TestRepl2
FROM DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.DIFF'
WITH STANDBY = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl2Standby.BAK'
, STATS = 10

ALTER DATABASE TestRepl2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE

RESTORE DATABASE TestRepl2
WITH RECOVERY

ALTER DATABASE TestRepl2 SET MULTI_USER

DROP DATABASE TestRepl2

--restore FULL with NORECOVERY

RESTORE DATABASE TestRepl2
FROM DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.BAK'
WITH
MOVE 'TestRepl' TO 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.mdf'
, MOVE 'TestReplSecondary' TO 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestReplSecondary.ndf'
, MOVE 'TestRepl_log' TO 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl_log.ldf'
, NORECOVERY
, STATS = 10

--restore DIFF with NORECOVERY

RESTORE DATABASE TestRepl2
FROM DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.DIFF'
WITH NORECOVERY
, STATS = 10

--restore TLog with RECOVERY

RESTORE LOG TestRepl2
FROM DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.TRN'
WITH RECOVERY
, STATS = 10

--backup filegroup

BACKUP DATABASE TestRepl
FILEGROUP = 'secondary' 
TO DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl_secondary.bak'
WITH STATS = 10

--insert some data into a file that is in the filegroup just backed up
INSERT INTO TestRepl3
VALUES (8, 16)

--filegroup restore

RESTORE DATABASE TestRepl2
FILE = 'TestReplSecondary'
,FILEGROUP = 'secondary'
FROM DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl_secondary.bak'
WITH STATS = 10
--, PARTIAL
, NORECOVERY

ALTER DATABASE TestRepl2
SET OFFLINE

ALTER DATABASE TestRepl2
SET ONLINE

BACKUP LOG TestRepl2 WITH NORECOVERY

DROP DATABASE TestRepl2

RESTORE DATABASE TestRepl2
WITH RECOVERY

--steps to do a partial restore

-- backup the tail log of the database that is online

BACKUP LOG TestRepl
TO DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl1.TRN' WITH NORECOVERY, NO_TRUNCATE


--PIECEMEAL RESTORE USING FILEGROUPS


/**Recover the primary FG**/
RESTORE DATABASE TestRepl2
FILEGROUP = 'primary'
FROM DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.BAK'
WITH
MOVE 'TestRepl' TO 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.mdf'
, MOVE 'TestRepl_log' TO 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl_log.ldf' 
, PARTIAL
, NORECOVERY

/**Restore the log with RECOVERY and bring the DB online partially**/
RESTORE LOG TestRepl2 
FROM DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.TRN'
WITH RECOVERY

/**Then backup the tail log of the newly restored DB before restoring the other FGs**/
BACKUP LOG TestRepl2 
TO DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl_fromTestRepl2.TRN'
WITH NORECOVERY

/**Restore the secondary FG with NORECOVERY**/
RESTORE DATABASE TestRepl2
FILEGROUP = 'secondary'
FROM DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.BAK'
WITH
MOVE 'TestReplSecondary' TO 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestReplSecondary.ndf'
, PARTIAL
, NORECOVERY

/**Restore log to roll forward transactions again with recovery to bring DB online**/
RESTORE LOG TestRepl2 
FROM DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.TRN'
WITH RECOVERY

/**Another tail log backup**//
BACKUP LOG TestRepl2 
TO DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl_fromTestRepl3.TRN'
WITH NORECOVERY

/**Restore the last FG with RECOVERY**//
RESTORE DATABASE TestRepl2
FILEGROUP = 'tertiary'
FROM DISK = 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl.BAK'
WITH
MOVE 'TestRepl_Tertiary' TO 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestReplTertiary.ndf'
--, MOVE 'TestRepl_log' TO 'C:\SQL Server\SQL 2012\DEN1LSS03\SQL Backups\TestRepl_log.ldf' 
, PARTIAL
, RECOVERY

DROP DATABASE TestRepl2

