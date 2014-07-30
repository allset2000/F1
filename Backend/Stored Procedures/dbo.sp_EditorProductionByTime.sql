SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_EditorProductionByTime]
	@startDate datetime,
	@endDate datetime,
	@EditorID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT dtDates.Date, InTime, OutTime, NumJobs, NumChars, NumVBC
	FROM
	(
		SELECT DISTINCT DATEADD(dd, Days.Row, DATEADD(mm, Months.Row, DATEADD(yy, Years.Row, @startDate))) AS Date
		FROM
		(SELECT 0 AS Row UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
		 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
		 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14
		 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19
		 UNION ALL SELECT 20 -- add more years here...
		) AS Years
		INNER JOIN
		(SELECT 0 AS Row UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
		 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
		 UNION ALL SELECT 10 UNION ALL SELECT 11
		) AS Months
		ON DATEADD(mm, Months.Row,  DATEADD(yy, Years.Row, @startDate)) <= @endDate 
		INNER JOIN
		(SELECT 0 AS Row UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
		 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
		 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14
		 UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19
		 UNION ALL SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24
		 UNION ALL SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29
		 UNION ALL SELECT 30
		) AS Days
		ON DATEADD(dd, Days.Row, DATEADD(mm, Months.Row,  DATEADD(yy, Years.Row, @startDate))) <= @endDate
		WHERE DATEADD(yy, Years.Row, @startDate) <= @endDate
	) dtDates LEFT OUTER JOIN
	(
		SELECT CONVERT(date, OperationTime, 101) AS InDate, MIN(OperationTime) AS InTime FROM EditorLogs 
		WHERE EditorID=@EditorID And OperationName='SignIn' And OperationTime >= @startDate And OperationTime < @endDate
		GROUP BY CONVERT(date, OperationTime, 101)
	) t_InTime ON dtDates.Date=t_InTime.InDate LEFT OUTER JOIN
	(
		SELECT CONVERT(date, OperationTime, 101) AS OutDate, MAX(OperationTime) AS OutTime FROM EditorLogs 
		WHERE EditorID=@EditorID And OperationName='SignOff' And OperationTime >= @startDate And OperationTime < @endDate
		GROUP BY CONVERT(date, OperationTime, 101)
	) t_OutTime ON dtDates.Date=t_OutTime.OutDate LEFT OUTER JOIN
	(
		SELECT CONVERT(date, ReturnedOn, 101) AS TotalDate, COUNT(*) AS NumJobs, SUM(NumChars_Editor) AS NumChars, SUM(NumVBC_Editor) AS NumVBC 
		FROM Jobs INNER JOIN Jobs_EditingData ON Jobs.JobNumber=Jobs_EditingData.JobNumber
		WHERE EditorID=@EditorID And ReturnedOn >= @startDate And ReturnedOn < @endDate
		GROUP BY CONVERT(date, ReturnedOn, 101)
	) t_Totals ON dtDates.Date=t_Totals.TotalDate
	ORDER BY Date
END
GO
