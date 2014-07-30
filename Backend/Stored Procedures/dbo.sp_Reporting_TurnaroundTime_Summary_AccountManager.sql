SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	Retrieves editor production data
				for report "Summary Turnaround Time by Account Manager.rdl"
				
change log

date		username		description
4/12/13		jablumenthal	updated stored proc to use new tables.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_TurnaroundTime_Summary_AccountManager]

	@BeginDate datetime, 
	@EndDate datetime,
	@AM varchar(max)

AS
BEGIN

	if object_id('tempdb..#AMs') is not null drop table #AMs

	--create temp tables & populate with parsed report variables
	create table #AMs (AcctManagerName varchar(max))
	insert into #AMs select id from dbo.ParamParserFn(@AM,',')

	SET NOCOUNT ON

	SELECT  CASE
				WHEN X.AcctManagerName IS NULL THEN 'Unknown'
				ELSE X.AcctManagerName
			END AS AcctManagerName,  
			C.ClinicName as [Clinic],
			J.JobNumber as [Job Number],
			J.ReceivedOn as [Received],
			J.CompletedOn as [Completed],
			DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as [TAT mins],
			CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [TAT hrs],
			COUNT(J2.JobNumber) AS OnTime,
			COUNT(J.JobNumber)  AS Total,
			SUM(BJ.NumVBC / 65.0) as Lines
			--SUM(JED.NumVBC_Job / 65.0) AS Lines
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	JOIN [Entrada].dbo.vwRptBillableJobs BJ WITH (NOLOCK) ON
		 J.JobNumber = BJ.JobNumber
	--JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON 
 --        J.JobNumber = JED.JobNumber
	LEFT OUTER JOIN [Entrada].[dbo].Dictators D WITH(NOLOCK) ON
		 J.DictatorID = D.DictatorID
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		 J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs J2 WITH(NOLOCK) ON
		 J.JobNumber = J2.JobNumber
		 AND (CAST((CAST(DATEDIFF(MI, J.ReceivedOn, J.CompletedOn) as DECIMAL(10,3)) / CAST(60 as DECIMAL(10,3))) AS DECIMAL(10,3)) < 24)
	LEFT OUTER JOIN [EntradaInternal].[dbo].Reporting_Clinic_AcctMgr_Xref X WITH (NOLOCK) ON
		 C.ClinicID = X.ClinicID
	WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	  AND (X.AcctManagerName in (select ltrim(rtrim(AcctManagerName)) from #AMs))
	GROUP BY CASE
				WHEN X.AcctManagerName IS NULL THEN 'Unknown'
				ELSE X.AcctManagerName
			 END,
			 C.ClinicName,
			 J.ReceivedOn,
			 J.CompletedOn,
			 J.JobNumber
	ORDER BY [OnTime],
			 CASE
				WHEN X.AcctManagerName IS NULL THEN 'Unknown'
				ELSE X.AcctManagerName
			 END,
			 C.ClinicName
		
END

GO
