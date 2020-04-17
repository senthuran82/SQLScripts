SELECT OBJECT_NAME(object_id) AS [ObjectName], auto_created, user_created
      ,[name] AS [StatisticName]
      ,STATS_DATE([object_id], [stats_id]) AS [StatisticUpdateDate]
FROM sys.stats;