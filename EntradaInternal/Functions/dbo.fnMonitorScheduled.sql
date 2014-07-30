SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[fnMonitorScheduled] (@ReportID int)
 
RETURNS bit

AS
 
BEGIN

	DECLARE @Begin time,
		@End time,
		@Invert bit,
		@RetVal bit


	SELECT @Begin = case
						when CAST(dteBeginTime as Time) > CAST(dteEndTime as Time) THEN CAST(dteEndTime as Time)
						else CAST(dteBeginTime as Time)
					end,
			@End = case
						when CAST(dteBeginTime as Time) > CAST(dteEndTime as Time) THEN CAST(dteBeginTime as Time)
						else CAST(dteEndTime as Time)
					end,
			@Invert = case
						when CAST(dteBeginTime as Time) > CAST(dteEndTime as Time) THEN 1
						else 0
					end
	FROM Monitor_Schedule
	WHERE intReportID = @ReportID AND
		DATEPART(DW, GetDate()) IN (SELECT INSTANCE FROM fnParseString (sScheduledDays, ',')) AND
		bitActive = 1  
			

	IF @Begin IS NULL
		BEGIN
			SET @RetVal = 0	
		END		
	ELSE
		BEGIN
			
			IF @Invert = 0
				BEGIN
					IF CAST(GetDate() AS TIME) BETWEEN @Begin and @End 
						SET @RetVal = 1
					ELSE
						SET @RetVal = 0			
				END
			ELSE
				BEGIN
					IF CAST(GetDate() AS TIME) NOT BETWEEN @Begin and @End
						SET @RetVal = 1
					ELSE
						SET @RetVal = 0			
				
				END
		END	
	

	RETURN @RetVal
	
END





GO
