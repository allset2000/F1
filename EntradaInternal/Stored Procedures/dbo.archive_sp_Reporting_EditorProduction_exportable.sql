SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*********************************************************
Author:			Charles Arnold
Create date:	3/8/2012
Description:	Retrieves turnaround summary data
				for report "Summary Turnaround Time (EXT).rdl"

change log:

date	user			description
3/18/13	jablumenthal	copied sp_Reporting_EditorProduction to 
						sp_Reporting_EditorProduction_exportable
						to create a downloadable Editor Production
						by Editor report to replace the one he is
						currently using that is crashing when he
						tries to download it to excel.
*********************************************************/
create PROCEDURE [dbo].[archive_sp_Reporting_EditorProduction_exportable]

	@BeginDate datetime, 
	@EndDate datetime,
	@ClinicCode varchar(25) 

AS
BEGIN
	
	SELECT  E.LastName + ', ' + E.FirstName AS [Editor],
			E.EditorID AS [Editor ID],
			C.ClinicName AS [Clinic],
			J.JobNumber AS [Job],
			jed.NumChars_Editor AS [Chars],
			(CAST(JED.NumVBC_Editor AS DECIMAL(10, 2)) / 65) AS [Lines],
			J.CompletedOn AS [Completed]
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		 J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Editors E WITH(NOLOCK) ON
		 J.EditorID = E.EditorID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON
		 J.JobNumber = JED.JobNumber
	WHERE J.ReturnedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	  AND C.ClinicCode = CASE @ClinicCode
							WHEN '- All -' THEN C.ClinicCode
							ELSE @ClinicCode
						 END
	ORDER BY E.LastName + ', ' + E.FirstName,
			 C.ClinicName

END

GO
