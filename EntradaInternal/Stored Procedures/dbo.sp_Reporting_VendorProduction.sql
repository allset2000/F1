SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	Retrieves editor production data
				for report "Group Production.rdl"
				
change log

date		username		description
4/11/13		jablumenthal	updated stored proc to use new tables.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_VendorProduction]

	@BeginDate datetime, 
	@EndDate datetime,
	@VendorCode varchar(max)

AS
BEGIN


	if object_id('tempdb..#vendors') is not null drop table #vendors

	--create temp table & populate with parsed report variable
	create table #vendors (vendor_code varchar(16))
	insert into #vendors select id from dbo.ParamParserFn(@VendorCode,',')

	
	SELECT  DC.CompanyName as VendorName,
			E.LastName + ', ' + E.FirstName AS [Editor],
			E.EditorID AS [Editor ID],
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
	LEFT OUTER JOIN [Entrada].[dbo].Editors_Pay EP WITH (NOLOCK) ON
		 E.EditorID = EP.EditorID
	LEFT OUTER JOIN [Entrada].[dbo].DSGCompanies DC WITH (NOLOCK) ON --Vendors
		 EP.PayType = DC.CompanyCode
	WHERE J.ReturnedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	  AND DC.CompanyCode in (select ltrim(rtrim(vendor_code)) from #vendors) 
	ORDER BY DC.CompanyName,
			 E.LastName + ', ' + E.FirstName

END
GO
