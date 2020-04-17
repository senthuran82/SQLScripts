CREATE TRIGGER DDL_Trigger_2
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS --ALTER_TABLE, DROP_TABLE, ALTER_PROCEDURE, CREATE_PROCEDURE, CREATE_TABLE
AS
INSERT INTO audit_table_2
SELECT 
 EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(200)')
,SUSER_SNAME()
,GETDATE()
,EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)')
, DB_NAME(DB_ID())

--,EVENTDATA().value ('(/EVENT_INSTANCE/ServerName)[1]','nvarchar(max)')
--,EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(200)')
--INSERT INTO audit_table
--VALUES ('Test', SUSER_SNAME(), GETDATE(), 'ALTER')

ALTER TABLE T1
ADD c12 INT

ALTER TABLE audit_table
ADD database_name VARCHAR (MAX)

DROP TABLE dbo.audit_table

DROP TRIGGER DDL_Trigger_1


CREATE TABLE audit_table_2
(
object_name_database  VARCHAR (MAX)
, [user] VARCHAR (MAX)
, date_time DATETIME
, activity VARCHAR (MAX)
, database_name VARCHAR (MAX)
)



SELECT *
FROM audit_table_2

SELECT EVENTDATA()

--<EVENT_INSTANCE><EventType>ALTER_TABLE</EventType><PostTime>2014-01-30T16:21:21.330</PostTime><SPID>53</SPID><ServerName>DEN1LSS03\I2</ServerName><LoginName>DATAVAIL\ssubramaniam</LoginName><UserName>dbo</UserName><DatabaseName>Test</DatabaseName><SchemaName>dbo</SchemaName><ObjectName>T1</ObjectName><ObjectType>TABLE</ObjectType><AlterTableActionList><Create><Columns><Name>c6</Name></Columns></Create></AlterTableActionList><TSQLCommand><SetOptions ANSI_NULLS="ON" ANSI_NULL_DEFAULT="ON" ANSI_PADDING="ON" QUOTED_IDENTIFIER="ON" ENCRYPTED="FALSE" /><CommandText>ALTER TABLE T1
--ADD c6 INT</CommandText></TSQLCommand></EVENT_INSTANCE>

CREATE PROCEDURE Audit_Proc
AS
SELECT 1

EXEC Audit_Proc

CREATE PROCEDURE Audit_Proc
AS
SELECT 1 AS Sample_Value

CREATE TABLE Audit_Test_2
(
c1 INT
, c2 INT
)
