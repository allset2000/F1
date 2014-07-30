SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create FUNCTION [dbo].[fnMonitorScheduled] (@ReportID int)
 
RETURNS bit

AS
 
BEGIN

	DECLARE @RetVal bit

	IF EXISTS(SELECT * FROM Monitor_Schedule
	WHERE intReportID = 1 AND
		DATEPART(DW, GETDATE()) IN (SELECT INSTANCE FROM fnParseString (sScheduledDays, ','))  AND
		CAST(GETDATE() AS TIME) BETWEEN CAST(dteBeginTime AS TIME) and CAST(dteEndTime AS TIME) AND
		bitActive = 1)
		SET @RetVal = 1
	ELSE
		SET @RetVal = 0
	

	RETURN @RetVal
	
END




GO
