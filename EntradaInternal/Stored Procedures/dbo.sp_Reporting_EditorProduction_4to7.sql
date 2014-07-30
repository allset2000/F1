SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Charles Arnold
Create date:	3/5/2012
Description:	Retrieves editor production data
				for report "Dictator Billing Summary.rdl"
				
change log

date		username		description
4/11/13		jablumenthal	updated stored proc to use new tables.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_EditorProduction_4to7]
--declare
	@BeginDate date, 
	@EndDate date,
	@ClinicCode varchar(25) 

--set @begindate = '2013-04-25'
--set @enddate = '2013-04-29'
--set @cliniccode = 'bnj'

AS
BEGIN

	SELECT  E.LastName + ', ' + E.FirstName AS [Editor],
			E.EditorID AS [Editor ID],
			C.ClinicName as [Clinic],
			J.JobNumber as [Job],
			EJ.NumChars as [Chars],
			(CAST(EJ.NumVBC AS DECIMAL(10, 2)) / 65) as [Lines],
			/*
			jed.NumChars_Editor as [Chars],
			(CAST(JED.NumVBC_Editor AS DECIMAL(10, 2)) / 65) as [Lines]
			*/
			J.CompletedOn
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON
		 J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [Entrada].[dbo].Editors E WITH(NOLOCK) ON
		 J.EditorID = E.EditorID
	--LEFT OUTER JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON
	--	 J.JobNumber = JED.JobNumber
	JOIN [Entrada].dbo.vwRptEditingJobs EJ WITH (NOLOCK) ON
		 J.JobNumber = EJ.JobNumber
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
