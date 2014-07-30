SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 1/27/2012
-- Description:	Retrieves totals for jobs received per day of week
--		over the past 90 days for report 
--		"Jobs Received Per DayOfWeek - 90day.rdl"
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_JobsReceived_90day] 

@ClinicID int

AS
BEGIN


	DECLARE @Date datetime

	SET @Date = CONVERT(VARCHAR , DATEADD(D, -90, GetDate()), 110);

			SELECT CAST(ReceivedOn as date) AS [Received Date], 
				DATEPART(DW, ReceivedOn) AS [DatePart],
				DATENAME(DW, ReceivedOn) AS [Day],
				DATEPART(hour,ReceivedOn) AS [Hour], 
				COUNT(*) AS [Num Received]
			FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
			LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
				J.ClinicID = C.ClinicID
			WHERE ReceivedOn >= @Date
				AND J.ClinicID = CASE @ClinicID
									WHEN -1 THEN J.ClinicID
									ELSE @ClinicID
								END
			GROUP BY CAST(ReceivedOn as date), 
					DATEPART(DW, ReceivedOn),
					DATENAME(DW, ReceivedOn),
					DATEPART(hour,ReceivedOn)
			ORDER BY [DatePart],
					[Day],
					[Hour],
					[Num Received]	
				
END
GO
