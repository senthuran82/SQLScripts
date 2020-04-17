SELECT CASE groupid WHEN 0 THEN 'Temp_Log' ELSE 'Temp_Data' END AS 'file_type', COUNT (*) AS file_count--, CASE CAST ([maxsize] AS INT) WHEN '-1' THEN 'No_Restrictions' WHEN '268435456'  THEN 'Default 2TB' WHEN 0 THEN 'No Growth' ELSE CAST ([maxsize] AS INT) END AS growth_factor
FROM sysaltfiles
WHERE [dbid] = 2
GROUP BY [groupid], [maxsize]


