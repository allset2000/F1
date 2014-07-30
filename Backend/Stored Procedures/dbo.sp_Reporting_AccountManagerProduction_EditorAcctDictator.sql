SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	Retrieves editor production data
				for report "Account Manager Production by Account.rdl"
				
change log

date		username		description
4/11/13		jablumenthal	updated stored proc to use new tables.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_AccountManagerProduction_EditorAcctDictator]

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
	SELECT  CASE
				WHEN X.AcctManagerName IS NULL THEN 'Unknown'
				ELSE X.AcctManagerName
			END AS AcctManagerName,  
			E.LastName + ', ' + E.FirstName AS [Editor],
			E.EditorID AS [Editor ID],
			C.ClinicName AS [Clinic],
			D.FirstName + ' ' + D.LastName as DictatorName,
			J.JobNumber AS [Job],
			EJ.NumChars as [Chars],
			(CAST(EJ.NumVBC as DECIMAL(10, 2)) / 65) as [Lines]
			/*
			jed.NumChars_Editor AS [Chars],
			(CAST(JED.NumVBC_Editor AS DECIMAL(10, 2)) / 65) AS [Lines]
			*/
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		 J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Editors E WITH(NOLOCK) ON
		 J.EditorID = E.EditorID
	JOIN [Entrada].dbo.vwRptEditingJobs EJ WITH (NOLOCK) ON
		 J.JobNumber = EJ.JobNumber
	--LEFT OUTER JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON
	--	 J.JobNumber = JED.JobNumber
	LEFT OUTER JOIN [EntradaInternal].[dbo].Reporting_Clinic_AcctMgr_Xref X WITH (NOLOCK) ON
		 C.ClinicID = X.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Dictators D WITH (NOLOCK) ON
		 J.DictatorID = D.DictatorID		 
	WHERE J.ReturnedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	  AND CASE
			WHEN X.AcctManagerName IS NULL THEN 'Unknown'
			ELSE X.AcctManagerName
		  END in (select ltrim(rtrim(AcctManagerName)) from #AMs)
	ORDER BY CASE
				WHEN X.AcctManagerName IS NULL THEN 'Unknown'
				ELSE X.AcctManagerName
			END,  
			E.LastName + ', ' + E.FirstName,
			C.ClinicName,
			D.FirstName + ' ' + D.LastName
			 
END
GO
