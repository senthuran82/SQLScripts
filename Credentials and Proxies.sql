--Credentials

SELECT @@SERVERNAME AS [server], [name], credential_identity, create_date 
FROM sys.credentials

--proxies

CREATE TABLE #dv_proxies
(
[proxy_id] INT
, [name] SYSNAME
, [credential_identity] SYSNAME
, [enabled] TINYINT
, [description] NVARCHAR(1024)
, [user_sid] VARBINARY(85)
, [credential_id] INT
, [credential_identity_exists] INT
)

INSERT INTO #dv_proxies
EXEC msdb.dbo.sp_help_proxy

SELECT @@SERVERNAME AS [server], [name], credential_identity, [enabled]
FROM #dv_proxies

DROP TABLE #dv_proxies