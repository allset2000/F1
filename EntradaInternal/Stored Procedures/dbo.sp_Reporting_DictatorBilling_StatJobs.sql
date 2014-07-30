SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Charles Arnold
Create date:	3/8/2012
Description:	Retrieves editor production data
				for report "Dictator Billing Stat Job Summary.rdl"
				
change log

date		username		description
4/11/13		jablumenthal	updated stored proc to use new tables.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_DictatorBilling_StatJobs] 

@BeginDate datetime,
@EndDate datetime

AS

BEGIN

SET NOCOUNT ON;

	SELECT	C.ClinicName, 
			J.DictatorID, 
			J.EditorID, 
			J.JobNumber,
			J.Stat, 
			SUM(BJ.NumPages) as NumPages,
			SUM(BJ.NumChars) as NumVBC,
			SUM(BJ.NumVBC) as NumChars,
			SUM(BJ.NumVBC / 65.0) as EntradaLines,
			SUM(BJ.DocumentWSpaces) as [NumChars w Spaces],
			SUM(BJ.DocumentWSpaces / 65.0) as [EntradaLines w Spaces]
			/*
			SUM(JED.NumPages_Job) as NumPages,
			SUM(JED.NumChars_Job) as NumVBC, 
			SUM(JED.NumVBC_Job) as NumChars, 
			SUM(JED.NumVBC_Job / 65.0) AS EntradaLines,
			SUM(JED2.[DocumentWSpaces_Job]) AS [NumChars w Spaces],
			SUM(JED2.[DocumentWSpaces_Job] / 65.0) AS [EntradaLines w Spaces]
			*/
	FROM [Entrada].[dbo].Clinics C WITH(NOLOCK)
	JOIN [Entrada].[dbo].Jobs J WITH(NOLOCK) ON 
		 c.ClinicID = J.ClinicID 
	JOIN [Entrada].dbo.vwRptBillableJobs BJ WITH (NOLOCK) ON
		 J.JobNumber = BJ.JobNumber
	--JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON 
	--     J.JobNumber = JED.JobNumber
	--JOIN [Entrada].[dbo].Jobs_EditingData2 JED2 WITH(NOLOCK) ON
	--	   J.JobNumber = JED2.JobNumber
	WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0) and J.Stat = 1
	GROUP BY C.ClinicName, 
		J.DictatorID, 
		J.EditorID,
		J.JobNumber,
		J.Stat
	ORDER BY C.ClinicName	

END
GO
