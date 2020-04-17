DECLARE @return_code INT;
DECLARE @TraceID INT;
DECLARE @maxfilesize BIGINT;
SET @maxfilesize = 5;
--step 1: create a new empty trace definition
EXEC sp_trace_create
                @traceid OUTPUT
               , @options = 2
               , @tracefile = N'C:\Trace\Sen_Trace_new2'
               , @maxfilesize = @maxfilesize
    , @stoptime =NULL
    , @filecount = 2;
-- step 2: add the events and columns
EXEC sp_trace_setevent
                @traceid = @TraceID
               , @eventid = 10 -- RPC:Completed
               , @columnid = 1 -- TextData
               , @on = 1;--include this column in trace
EXEC sp_trace_setevent
                @traceid = @TraceID
               , @eventid = 10 -- RPC:Completed
               , @columnid = 13 --Duration
               , @on = 1;--include this column in trace
EXEC sp_trace_setevent
                @traceid = @TraceID
               , @eventid = 10 -- RPC:Completed
               , @columnid = 15 --EndTime
               , @on = 1;--include this column in trace  
EXEC sp_trace_setevent
                @traceid = @TraceID
               , @eventid = 12 -- SQL:BatchCompleted
               , @columnid = 1 -- TextData
               , @on = 1;--include this column in trace
EXEC sp_trace_setevent
                @traceid = @TraceID
               , @eventid = 12 -- SQL:BatchCompleted
               , @columnid = 13 --Duration
               , @on = 1;--include this column in trace
EXEC sp_trace_setevent
                @traceid = @TraceID
               , @eventid = 12 -- SQL:BatchCompleted
               , @columnid = 15 --EndTime
               , @on = 1;--include this column in trace
			   EXEC sp_trace_setevent
                @traceid = @TraceID
               , @eventid = 14 -- SQL:BatchCompleted
               , @columnid = 11 --EndTime
               , @on = 1;--include this column in trace        
-- step 3: add duration filter
--DECLARE @DurationFilter BIGINT;
--SET @DurationFilter = 10000000; --duration in microseconds
--EXEC sp_trace_setfilter
--                @traceid = @TraceID
--               , @columnid = 13
--               , @logical_operator = 0 --AND
--               , @comparison_operator = 4 -- greater than or equal to
--               , @value = @DurationFilter; --filter value
--SELECT @TraceID AS TraceID;

DECLARE @LoginName NVARCHAR;
SET @LoginName = N'%datavail\ssubramniam%'; --Login Name
--EXEC sp_trace_setfilter
--                @traceid = @TraceID
--               , @columnid = 14 -- Login Name
--               , @logical_operator = 1 --AND
--               , @comparison_operator = 6 -- greater than or equal to
--               , @value = @LoginName; --filter value
--SELECT @TraceID AS TraceID;

EXEC sp_trace_setfilter  @TraceID, 11, 0, 0, N'DATAVAIL\ssubramaniam'

EXEC sp_trace_setstatus 6, 1
EXEC sp_trace_setstatus 6, 0
EXEC sp_trace_setstatus 6, 2

EXEC sys.fn_trace_getinfo 

SELECT *
FROM fn_trace_gettable ( N'C:\Trace\Sen_Trace_new2.trc' , 1 )