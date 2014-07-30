SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Charles Arnold
Create date:	3/5/2012
Description:	Retrieves editor production data
				for report "Dictator Billing Summary.rdl"
				
change log:

date		username		description
4/11/13		jablumenthal	archived this proc and replaced
							with a new version using the 
							new QA workflow tables.
======================================================= */
CREATE PROCEDURE [dbo].[archive_sp_Reporting_DictatorBillingSummary] 

@BeginDate datetime,
@EndDate datetime

AS

BEGIN

SET NOCOUNT ON;

SELECT	C.ClinicName, 
		J.DictatorID, 
		J.EditorID, 
		COUNT(J.JobNumber) as NumJobs, 
		SUM(JED.NumPages_Job) as NumPages,
		SUM(JED.NumChars_Job) as NumVBC, 
		SUM(JED.NumVBC_Job) as NumChars, 
		SUM(JED.NumVBC_Job / 65.0) AS EntradaLines,
		SUM(JED2.[DocumentWSpaces_Job]) AS [NumChars w Spaces],
		SUM(JED2.[DocumentWSpaces_Job] / 65.0) AS [EntradaLines w Spaces]

FROM [Entrada].[dbo].Clinics C WITH(NOLOCK)
	INNER JOIN [Entrada].[dbo].Jobs J WITH(NOLOCK) ON 
		  c.ClinicID = J.ClinicID 
	INNER JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON 
          J.JobNumber = JED.JobNumber
    INNER JOIN [Entrada].[dbo].Jobs_EditingData2 JED2 WITH(NOLOCK) ON
		  J.JobNumber = JED2.JobNumber
WHERE J.CompletedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
GROUP BY C.ClinicName, 
		 J.DictatorID, 
		 J.EditorID	
	
END

GO
