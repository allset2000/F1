SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Jen Blumenthal
Create date:	3/20/2013
Description:	created for Cindy Gulley.  Shows production 
				for each Account Manager's group of accounts. 
				Need Account Manager name, account, jobs, lines, 
				dates, drill-down account then to editor, 
				editor ID, job #.
======================================================= */
create PROCEDURE [dbo].[archive_sp_Reporting_AccountManagerProduction]

	@BeginDate datetime, 
	@EndDate datetime,
	@AM varchar(max)  --account managers
	
AS
BEGIN


	if object_id('tempdb..#AMs') is not null drop table #AMs
	
	--create temp tables & populate with parsed report variables
	create table #AMs (AcctManagerName varchar(max))
	insert into #AMs select id from dbo.ParamParserFn(@AM,',')


	--get data using temp table & params
	SELECT  E.LastName + ', ' + E.FirstName AS [Editor],
			E.EditorID AS [Editor ID],
			C.ClinicName AS [Clinic],
			CASE
				WHEN X.AcctManagerName IS NULL THEN 'Unknown'
				ELSE X.AcctManagerName
			END AS AcctManagerName,  
			J.JobNumber AS [Job],
			jed.NumChars_Editor AS [Chars],
			(CAST(JED.NumVBC_Editor AS DECIMAL(10, 2)) / 65) AS [Lines]
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		 J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Editors E WITH(NOLOCK) ON
		 J.EditorID = E.EditorID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON
		 J.JobNumber = JED.JobNumber
	LEFT OUTER JOIN [EntradaInternal].[dbo].Reporting_Clinic_AcctMgr_Xref X WITH (NOLOCK) ON
		 C.ClinicID = X.ClinicID
	WHERE J.ReturnedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	  AND CASE
			WHEN X.AcctManagerName IS NULL THEN 'Unknown'
			ELSE X.AcctManagerName
		  END in (select ltrim(rtrim(AcctManagerName)) from #AMs)
	ORDER BY CASE
				WHEN X.AcctManagerName IS NULL THEN 'Unknown'
				ELSE X.AcctManagerName
			 END,
			 C.ClinicName,
			 E.LastName + ', ' + E.FirstName
			 
END
GO
