SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Jennifer Blumenthal
Create date:	4/5/13
Description:	Retrieves turnaround summary data for STAT jobs
				for report "Summary Turnaround Time (STAT).rdl"

change log:
date		username		description
7/26/13		jablumenthal	changed the on-time calculation
							to 2 hours per Cindy Gulley
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_TurnaroundTime_Summary_STAT]

	@BeginDate datetime, 
	@EndDate datetime,
	@ClinicCode varchar(max)

AS
BEGIN

	if object_id('tempdb..#clinic') is not null drop table #clinic

	--create temp tables & populate with parsed report variables
	create table #clinic (ClinicCode varchar(max))
	insert into #clinic select id from dbo.ParamParserFn(@ClinicCode,',')

	SET NOCOUNT ON

	SELECT  C.ClinicName as [Clinic],
			J.JobNumber as [Job Number],
			J.ReceivedOn as [Received],
			J.CompletedOn as [Completed],
			DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TAT mins],
			CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs],
			COUNT(J2.JobNumber) AS OnTime,
			COUNT(J.JobNumber)  AS Total,
			SUM(JED.NumVBC_Job / 65.0) AS Lines
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON 
         J.JobNumber = JED.JobNumber
	LEFT OUTER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
		 J.DictatorID = D.DictatorID
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		 J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs J2 WITH(NOLOCK) ON
		 J.JobNumber = J2.JobNumber
		 AND (CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) <= 2)
	WHERE J.Stat = 1  --STAT jobs only
	  AND J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	  AND (C.ClinicCode in (select ltrim(rtrim(ClinicCode)) from #clinic))
	GROUP BY C.ClinicName,
			 J.ReceivedOn,
			 J.CompletedOn,
			 J.JobNumber
	ORDER BY [OnTime],
			 C.ClinicName
		
END

GO
