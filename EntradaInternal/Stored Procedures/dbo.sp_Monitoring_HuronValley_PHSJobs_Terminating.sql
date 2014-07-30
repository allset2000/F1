SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Charles Arnold
-- Create date: 4/23/2012
-- Description:	Notifies On-Call editors of any 
--		Huron Valley jobs that we receive over 
--		the weekend. 
--		For report "Huron Valley - PHS Jobs Received.rdl"

-- =============================================


CREATE PROCEDURE [dbo].[sp_Monitoring_HuronValley_PHSJobs_Terminating]

	@Part int   --- 1 = Initializing
				--- 0 = Terminating

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @NumCount int,
			@Begin time,
			@End time,
			@BeginDateTime datetime,
			@EndDateTime datetime,
			@Invert bit,
			@RetVal bit,
			@SchedID bigint,
			@LastRun datetime,
			@BaseDate datetime
	
	
	IF dbo.fnMonitorScheduled(3) = 0
		BEGIN
			SELECT 1/0
		END
	ELSE		
		BEGIN
	
			SET @BaseDate = GETDATE()
			
			
			SELECT 	@Begin = CAST(dteBeginTime as Time),
					@End = CAST(dteEndTime as Time),
					@Invert = case
								when CAST(dteBeginTime as Time) > CAST(dteEndTime as Time) THEN 1
								else 0
							end,
					@SchedID = bintScheduleID,
					@LastRun = dteLastRun
			FROM Monitor_Schedule
			WHERE intReportID = 3 AND
				DATEPART(DW, @BaseDate) IN (SELECT INSTANCE FROM fnParseString (sScheduledDays, ','))  
				
			IF @Begin IS NULL
				BEGIN
					SELECT 1/0
				END		
			ELSE
				BEGIN
					
					IF @Invert = 0
						BEGIN
							SET @BeginDateTime = CAST(CAST(CAST(@BaseDate AS DATE) AS VARCHAR(10)) + ' ' + CAST(@Begin AS VARCHAR(10)) AS DATETIME)
							SET @EndDateTime = CAST(CAST(CAST(@BaseDate AS DATE) AS VARCHAR(10)) + ' ' + CAST(@End AS VARCHAR(10)) AS DATETIME)
						END
					ELSE
						BEGIN
						
							IF DATEPART(HOUR, @BaseDate) <= DATEPART(HOUR, @End)
								BEGIN
									SET @BeginDateTime = DATEADD(DAY, -1, CAST(CAST(CAST(@BaseDate AS DATE) AS VARCHAR(10)) + ' ' + CAST(@Begin AS VARCHAR(10)) AS DATETIME))
									SET @EndDateTime = CAST(CAST(CAST(@BaseDate AS DATE) AS VARCHAR(10)) + ' ' + CAST(@End AS VARCHAR(10)) AS DATETIME)
								END
							ELSE
								BEGIN
									SET @BeginDateTime = CAST(CAST(CAST(@BaseDate AS DATE) AS VARCHAR(10)) + ' ' + CAST(@Begin AS VARCHAR(10)) AS DATETIME) 
									SET @EndDateTime = DATEADD(DAY, 1, CAST(CAST(CAST(@BaseDate AS DATE) AS VARCHAR(10)) + ' ' + CAST(@End AS VARCHAR(10)) AS DATETIME))
								END
						END				
		
			IF @Part = 1
				BEGIN
					
					IF @LastRun IS NOT NULL AND DATEDIFF(HOUR, @LastRun, @BaseDate) < 24
						BEGIN
							SELECT 1/0
						END
					
					ELSE
						BEGIN
							SELECT @NumCount = COUNT(*)
							FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
							INNER JOIN [Entrada].[dbo].Jobs_Custom JC WITH(NOLOCK) ON
								J.JobNumber = JC.JobNumber
							WHERE J.ClinicID = 45 AND
								JC.Custom9 = 'PHS' AND
								ReceivedOn BETWEEN @BeginDateTime AND @EndDateTime
						
							
							IF @NumCount > 0
								BEGIN
									UPDATE Monitor_Schedule
									SET dteLastRun = DATEADD(MINUTE, -1, @BeginDateTime)
									WHERE bintScheduleID = @SchedID
									
									SELECT TOP 1 JC.Custom11 AS [PatientID],
										JP.MRN,
										JC.Custom5 AS [Procedure],
										J.ReceivedOn,
										CASE J.STAT
											WHEN 1 THEN 'Y'
											ELSE 'N'
										END AS [Stat]
									FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
									INNER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
										J.DictatorID = D.DictatorID
									INNER JOIN [Entrada].[dbo].Jobs_Custom JC WITH(NOLOCK) ON
										J.JobNumber = JC.JobNumber
									INNER JOIN [Entrada].[dbo].[Jobs_Patients] JP WITH(NOLOCK) ON
										J.JobNumber = JP.JobNumber
									WHERE J.ClinicID = 45 AND
										JC.Custom9 = 'PHS' AND
										ReceivedOn BETWEEN @BeginDateTime AND @EndDateTime
									ORDER BY J.ReceivedOn
								END
							ELSE
								BEGIN
									SELECT 1/0
								END
						END
				END
			ELSE
				BEGIN
					SELECT TOP 1 JC.Custom11 AS [PatientID],
						JP.MRN,
						JC.Custom5 AS [Procedure],
						J.ReceivedOn,
						CASE J.STAT
							WHEN 1 THEN 'Y'
							ELSE 'N'
						END AS [Stat]
					FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
					INNER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
						J.DictatorID = D.DictatorID
					INNER JOIN [Entrada].[dbo].Jobs_Custom JC WITH(NOLOCK) ON
						J.JobNumber = JC.JobNumber
					INNER JOIN [Entrada].[dbo].[Jobs_Patients] JP WITH(NOLOCK) ON
						J.JobNumber = JP.JobNumber						
					WHERE J.ClinicID = 45 AND
						JC.Custom9 = 'PHS' AND
						ReceivedOn BETWEEN @BeginDateTime AND @EndDateTime
					ORDER BY J.ReceivedOn DESC
					
				END
			END
		END
END

	


GO
