SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Returns Begin and End datetime values for range comparisons.  
--ReportID must be within scheduled DAY for valid return values.
CREATE PROCEDURE [dbo].[sp_Monitoring_ScheduleDetail]

	@ReportID int
	
AS

BEGIN

	DECLARE @Begin time,
		@End time,
		@Invert bit,
		@RetVal bit


			--@Begin = case
			--			when CAST(dteBeginTime as Time) > CAST(dteEndTime as Time) THEN CAST(dteEndTime as Time)
			--			else CAST(dteBeginTime as Time)
			--		end,
			--@End = case
			--			when CAST(dteBeginTime as Time) > CAST(dteEndTime as Time) THEN CAST(dteBeginTime as Time)
			--			else CAST(dteEndTime as Time)
			--		end,
			
	SELECT 	@Begin = CAST(dteBeginTime as Time),
			@End = CAST(dteEndTime as Time),
			@Invert = case
						when CAST(dteBeginTime as Time) > CAST(dteEndTime as Time) THEN 1
						else 0
					end
	FROM Monitor_Schedule
	WHERE intReportID = 1 AND
		DATEPART(DW, GetDate()) IN (SELECT INSTANCE FROM fnParseString (sScheduledDays, ','))  
		
	IF @Begin IS NULL
		BEGIN
			SELECT NULL, NULL, NULL	
		END		
	ELSE
		BEGIN
			
			IF @Invert = 0
				BEGIN
					SELECT CAST(CAST(CAST(GETDATE() AS DATE) AS VARCHAR(10)) + ' ' + CAST(@Begin AS VARCHAR(10)) AS DATETIME) AS [Begin],
						CAST(CAST(CAST(GETDATE() AS DATE) AS VARCHAR(10)) + ' ' + CAST(@End AS VARCHAR(10)) AS DATETIME) AS [End]
				END
			ELSE
				BEGIN
				
					IF DATEPART(HOUR, GETDATE()) < DATEPART(HOUR, @End)
					--IF CAST(GetDate() AS TIME) NOT BETWEEN @Begin and @End
						SELECT DATEADD(DAY, -1, CAST(CAST(CAST(GETDATE() AS DATE) AS VARCHAR(10)) + ' ' + CAST(@Begin AS VARCHAR(10)) AS DATETIME)) AS [Begin],
							CAST(CAST(CAST(GETDATE() AS DATE) AS VARCHAR(10)) + ' ' + CAST(@End AS VARCHAR(10)) AS DATETIME) AS [End]
					ELSE
						SELECT CAST(CAST(CAST(GETDATE() AS DATE) AS VARCHAR(10)) + ' ' + CAST(@Begin AS VARCHAR(10)) AS DATETIME) AS [Begin],
							DATEADD(DAY, 1, CAST(CAST(CAST(GETDATE() AS DATE) AS VARCHAR(10)) + ' ' + CAST(@End AS VARCHAR(10)) AS DATETIME)) AS [End]
				
				END
		END	

END


GO
