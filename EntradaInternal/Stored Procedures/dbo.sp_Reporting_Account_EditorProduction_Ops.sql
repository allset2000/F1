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
CREATE PROCEDURE [dbo].[sp_Reporting_Account_EditorProduction_Ops]

	@ReceivedOn datetime, 
	@ReceivedOn2 datetime,
	@PayTypeVar varchar(max)

AS

BEGIN

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
	WHERE J.ReturnedOn BETWEEN dateadd(dd, datediff(dd, 0, @ReceivedOn)+0, 0)  AND dateadd(dd, datediff(dd, 0, @ReceivedOn2)+1, 0)
	  AND C.ClinicCode = @PayTypeVar
	ORDER BY CASE
				WHEN ISNULL(E.LastName, '') = '' AND ISNULL(E.FirstName, '') = '' THEN 'UNKNOWN'
				WHEN ISNULL(E.LastName, '') = '' THEN ltrim(E.FirstName)
				WHEN ISNULL(E.FirstName, '') = '' THEN ltrim(E.LastName)
				ELSE ltrim(E.LastName) + ', ' + ltrim(E.FirstName)
			 END,
			 C.ClinicName


END

GO
