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
CREATE PROCEDURE [dbo].[sp_Reporting_VolumeAnalysis] 

AS
BEGIN

	SELECT [DayOrder] = CASE [Day]
							WHEN 'mon' THEN 1
							WHEN 'tue' THEN 2
							WHEN 'wed' THEN 3
							WHEN 'thu' THEN 4
							WHEN 'fri' THEN 5
							WHEN 'sat' THEN 6
							WHEN 'sun' THEN 7
						END,
		UPPER([Day]) AS [Day],
	--COUNT(*),
	--MIN(CAST([ExamDate] AS DATE)),
	--MAX(CAST([ExamDate] AS DATE)),
	--DATEDIFF(WEEK, MIN(CAST([ExamDate] AS DATE)), MAX(CAST([ExamDate] AS DATE))),
		(COUNT(*)/DATEDIFF(WEEK, MIN(CAST([ExamDate] AS DATE)), MAX(CAST([ExamDate] AS DATE)))) AS [Avg Jobs],
		 AVG(CAST([LineCount] AS DECIMAL(10,2))) AS [Avg Lines]
	FROM [EntradaInternal].[dbo].[VolumeAnalysis]
	WHERE  ([Day] IN ('mon', 'tue', 'wed', 'thu', 'fri') AND ((CAST(SUBSTRING([ExamEndTime], 1, 2) AS INT) >= 17) OR (CAST(SUBSTRING([ExamEndTime], 1, 2) AS INT) <= 5))) OR
		[Day] IN ('sun', 'sat')
	GROUP BY [Day]	
	order by [DayOrder]
				
END
GO
