EXEC master.sys.sp_altermessage 1205, 'WITH_LOG', TRUE;
GO
EXEC master.sys.sp_altermessage 3928, 'WITH_LOG', TRUE;
GO

DBCC TRACESTATUS (1204, -1)
DBCC TRACESTATUS (1222, -1)

DBCC TRACEON (1204, -1)
DBCC TRACEON (1222, -1)

SELECT
     xed.value('@timestamp', 'datetime2(3)') as CreationDate,
     xed.query('.') AS XEvent
FROM
(
     SELECT CAST([target_data] AS XML) AS TargetData
     FROM sys.dm_xe_session_targets AS st
     INNER JOIN sys.dm_xe_sessions AS s
            ON s.address = st.event_session_address
     WHERE s.name = N'system_health'
                 AND st.target_name = N'ring_buffer'
) AS Data
CROSS APPLY TargetData.nodes('RingBufferTarget/event[@name="xml_deadlock_report"]') AS XEventData (xed)
ORDER BY CreationDate DESC 

--Set up an operator and an alert

--https://solutioncenter.apexsql.com/sql-server-deadlocks-notifications-part-1/