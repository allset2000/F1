SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Charles Arnold
Create date:	3/8/2012
Description:	Retrieves editor production data
				for report "Editor Production (by Clinic 4-7).rdl"
				
change log:

date		username		description
4/11/13		jablumenthal	archived this proc and replaced
							with a new version using the 
							new QA workflow tables.
======================================================= */

create PROCEDURE [dbo].[archive_sp_Reporting_EditorProduction_4to7]

	@BeginDate date, 
	@EndDate date,
	@ClinicCode varchar(25) 

AS
BEGIN

	SELECT E.LastName + ', ' + E.FirstName AS [Editor],
		E.EditorID AS [Editor ID],
		C.ClinicName as [Clinic],
		J.JobNumber as [Job],
		jed.NumChars_Editor as [Chars],
		(CAST(JED.NumVBC_Editor AS DECIMAL(10, 2)) / 65) as [Lines]
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Editors E WITH(NOLOCK) ON
		J.EditorID = E.EditorID
	LEFT OUTER JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON
		J.JobNumber = JED.JobNumber
	--WHERE J.ReturnedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	WHERE CAST(J.ReturnedOn AS DATE) BETWEEN @BeginDate AND @EndDate 
		AND (CAST(J.ReturnedOn AS TIME) >= '16:00:00' OR CAST(J.ReturnedOn AS TIME) <= '07:00:00')
		AND C.ClinicCode = CASE @ClinicCode
								WHEN '- All -' THEN C.ClinicCode
								ELSE @ClinicCode
							END
	ORDER BY E.LastName + ', ' + E.FirstName,
			C.ClinicName

END

GO
