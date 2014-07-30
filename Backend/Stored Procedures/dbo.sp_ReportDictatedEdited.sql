SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ReportDictatedEdited] 
	-- Add the parameters for the stored procedure here
	@startDate datetime,
	@endDate datetime,
	@ClinicID smallint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT dtDates.Date, t_Dictated.NumJobs as NumDictated, t_Edited.NumJobs as NumReturned
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
		SELECT COUNT(*) as NumJobs, CONVERT(date,ReceivedOn,101) as Received FROM Jobs 
		WHERE ClinicID=@ClinicID And ReceivedOn>=@startDate And ReceivedOn<@endDate
		GROUP BY CONVERT(date,ReceivedOn,101)
	) t_Dictated on dtDates.Date=t_Dictated.Received
	LEFT OUTER JOIN
	(
		SELECT COUNT(*)as NumJobs, CONVERT(date,ReturnedOn,101) as Returned FROM Jobs 
		WHERE ClinicID=@ClinicID And ReturnedOn>=@startDate And ReturnedOn<@endDate 
		GROUP BY CONVERT(date,ReturnedOn,101)
	) t_Edited on dtDates.Date=t_Edited.Returned
	ORDER BY dtDates.Date
    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
END
GO
