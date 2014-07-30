SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Charles Arnold
Create date:	3/8/2012
Description:	Retrieves editor production data
				for report "Editor Production (by Clinic).rdl"
				
change log

date		username		description
4/11/13		jablumenthal	updated stored proc to use new tables.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_EditorProduction_ByClinic]

	@BeginDate datetime, 
	@EndDate datetime,
	@ClinicCode varchar(25) 

AS
BEGIN
	
	SELECT  E.LastName + ', ' + E.FirstName AS [Editor],
			E.EditorID AS [Editor ID],
			C.ClinicName AS [Clinic],
			J.JobNumber AS [Job],
			EJ.NumChars as [Chars],
			(CAST(EJ.NumVBC AS DECIMAL(10, 2)) / 65) AS [Lines],
			/*
			jed.NumChars_Editor AS [Chars],
			(CAST(JED.NumVBC_Editor AS DECIMAL(10, 2)) / 65) AS [Lines],
			*/
			J.CompletedOn AS [Completed]
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		 J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Editors E WITH(NOLOCK) ON
		 J.EditorID = E.EditorID
	JOIN [Entrada].dbo.vwRptEditingJobs EJ WITH (NOLOCK) ON
		 J.JobNumber = EJ.JobNumber
	--LEFT OUTER JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON
	--	 J.JobNumber = JED.JobNumber
	WHERE J.ReturnedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	  AND C.ClinicCode = CASE @ClinicCode
							WHEN '- All -' THEN C.ClinicCode
							ELSE @ClinicCode
						 END
	ORDER BY E.LastName + ', ' + E.FirstName,
			 C.ClinicName

END
GO
