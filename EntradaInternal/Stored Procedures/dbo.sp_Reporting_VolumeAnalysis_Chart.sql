SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 1/27/2012
-- Description:	Retrieves jobs that may be billed
--		twice  for report "Billing Duplicates.rdl"
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_VolumeAnalysis_Chart] 



AS
BEGIN

	SELECT [Facility],
      CAST([ExamDate] AS DATE) AS [Exam Date],
      CAST([ExamStartTime] AS TIME) AS [Start Time],
      CAST([ExamEndTime] AS TIME) AS [End Time],
      [AccessionNo],
      [Modality],
      [Procedure],
      [ExamStatus],
      [DayOrder] = CASE [Day]
							WHEN 'mon' THEN 1
							WHEN 'tue' THEN 2
							WHEN 'wed' THEN 3
							WHEN 'thu' THEN 4
							WHEN 'fri' THEN 5
							WHEN 'sat' THEN 6
							WHEN 'sun' THEN 7
						END,
		UPPER([Day]) as [Day],
     [LineCount]
	FROM [EntradaInternal].[dbo].[VolumeAnalysis]
	WHERE  ([Day] IN ('mon', 'tue', 'wed', 'thu', 'fri') AND ((CAST(SUBSTRING([ExamEndTime], 1, 2) AS INT) >= 17) OR (CAST(SUBSTRING([ExamEndTime], 1, 2) AS INT) <= 5))) OR
		[Day] IN ('sun', 'sat')
	order by [DayOrder]
				
END
GO
