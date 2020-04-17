SELECT dp2.[name] AS [Login Name]
, dp.[name] AS [Database Role]
, dp.type_desc AS [Login Type]
FROM sys.database_principals dp
INNER JOIN sys.database_role_members dpr
ON dp.principal_id = dpr.role_principal_id
LEFT OUTER JOIN sys.database_principals dp2
ON dpr.member_principal_id = dp2.principal_id


--MSDN Script
SELECT DP1.name AS DatabaseRoleName,   
   isnull (DP2.name, 'No members') AS DatabaseUserName   
 FROM sys.database_role_members AS DRM  
 RIGHT OUTER JOIN sys.database_principals AS DP1  
   ON DRM.role_principal_id = DP1.principal_id  
 LEFT OUTER JOIN sys.database_principals AS DP2  
   ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R'
ORDER BY DP1.name;