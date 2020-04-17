SELECT *
FROM sysaltfiles

ALTER DATABASE [model]
MODIFY FILE 
(NAME = 'modeldev'
, FILENAME = 'C:\SQL\model.mdf'
)

GO

ALTER DATABASE [model]
MODIFY FILE 
(NAME = 'modellog'
, FILENAME = 'C:\SQL\modellog.ldf'
)

ALTER DATABASE [msdb]
MODIFY FILE
(NAME = 'MSDBData'
, FILENAME = 'C:\SQL\MSDBData.mdf'
)

ALTER DATABASE [msdb]
MODIFY FILE
(NAME = 'MSDBLog'
, FILENAME = 'C:\SQL\MSDBlog.mdf'
)
