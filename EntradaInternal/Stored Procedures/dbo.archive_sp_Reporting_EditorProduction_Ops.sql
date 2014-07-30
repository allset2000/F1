SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/**********************************************************
Author:			Jen Blumenthal
Create date:	3/19/2013
Description:	created for Cindy Gulley.  
				Editor name/Editor ID/lines/jobs with drill-down 
				by account/lines/jobs
**********************************************************/
create PROCEDURE [dbo].[archive_sp_Reporting_EditorProduction_Ops]

	@BeginDate datetime, 
	@EndDate datetime,
	@ClinicCode varchar(max),
	@EditorID varchar(max)

AS
BEGIN
	

	if object_id('tempdb..#clinics') is not null drop table #clinics
	if object_id('tempdb..#editors') is not null drop table #editors

	
	--create temp tables & populate with parsed report variables
	create table #clinics (clinic varchar(max))
	insert into #clinics select id from dbo.ParamParserFn(@cliniccode,',')

	create table #editors (editorID varchar(max))
	insert into #editors select id from dbo.ParamParserFn(@editorID, ',')


	--get data using temp table & params
	SELECT  CASE
				WHEN ISNULL(E.LastName, '') = '' AND ISNULL(E.FirstName, '') = '' THEN 'UNKNOWN'
				WHEN ISNULL(E.LastName, '') = '' THEN ltrim(E.FirstName)
				WHEN ISNULL(E.FirstName, '') = '' THEN ltrim(E.LastName)
				ELSE ltrim(E.LastName) + ', ' + ltrim(E.FirstName)
			END AS [Editor],
			E.EditorID AS [Editor ID],
			C.ClinicName AS [Clinic],
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
	WHERE J.ReturnedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	  AND C.ClinicCode in (select ltrim(rtrim(clinic)) from #clinics)
	  AND J.EditorID in (select ltrim(rtrim(editorID)) from #editors)
	ORDER BY CASE
				WHEN ISNULL(E.LastName, '') = '' AND ISNULL(E.FirstName, '') = '' THEN 'UNKNOWN'
				WHEN ISNULL(E.LastName, '') = '' THEN ltrim(E.FirstName)
				WHEN ISNULL(E.FirstName, '') = '' THEN ltrim(E.LastName)
				ELSE ltrim(E.LastName) + ', ' + ltrim(E.FirstName)
			 END,
			 C.ClinicName


END


GO
