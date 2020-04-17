EXEC sp_change_users_login 'Report'

--Use below code to fix the Orphan User issue
DECLARE @username varchar(25)
DECLARE fixusers CURSOR 
FOR
SELECT UserName = name FROM sysusers
WHERE issqluser = 1 and (sid is not null and sid <> 0x0)
and suser_sname(sid) is null
ORDER BY name
OPEN fixusers
FETCH NEXT FROM fixusers
INTO @username
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC sp_change_users_login 'update_one', @username, @username
FETCH NEXT FROM fixusers
INTO @username 
END
CLOSE fixusers
DEALLOCATE fixusers
