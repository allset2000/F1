SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 1/27/2012
-- Description:	Retrieves turnaround summary data
--				for report "Jobs Dictated and Edited Per Day (ENT).rdl"
--
-- Edits:
-- 2/4/13	jablumenthal	added DictatorID & DictatorName per Jeff McNeese request
-- 2/11/13	jablumenthal	added ClinicCode per Cindy Gully request
-- =============================================
create PROCEDURE [dbo].[archive_sp_Reporting_JobsDictatedAndEdited_PerDay_ENT]

	@BeginDate datetime, 
	@EndDate datetime

AS
BEGIN

SET NOCOUNT ON
SET CONCAT_NULL_YIELDS_NULL OFF


	SELECT  CONVERT(DATE, J.ReceivedOn, 101) AS StartDate, 
			CONVERT(DATE, J.ReceivedOn, 101) AS EndDate, 
			J.ClinicID, 
			C.ClinicName + CASE
							 WHEN ISNULL(C.ClinicCode, '') = '' then NULL
							 ELSE ' (' + C.ClinicCode + ')'
						   END as ClinicName, 
			coalesce(D.signature, D.FirstName + ' ' + D.LastName + D.Suffix) as DictatorName,
			COUNT(DISTINCT(J.JobNumber)) as [Jobs Received],
			0 as [Jobs Returned],
			0 as [Lines]
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON 
		 J.ClinicID = C.ClinicID
	JOIN Entrada.dbo.Dictators D ON
		 J.DictatorID = D.DictatorID
	WHERE J.ReceivedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)
	GROUP BY CONVERT(DATE, J.ReceivedOn, 101),
		J.ClinicID, 
			C.ClinicName + CASE
							 WHEN ISNULL(C.ClinicCode, '') = '' then NULL
							 ELSE ' (' + C.ClinicCode + ')'
						   END, 
		coalesce(D.signature, D.FirstName + ' ' + D.LastName + D.Suffix)
		
	UNION ALL

	SELECT  CONVERT(DATE, J.ReturnedOn, 101) AS StartDate, 
			CONVERT(DATE, J.ReturnedOn, 101) AS EndDate, 
			J.ClinicID, 
			C.ClinicName + CASE
							 WHEN ISNULL(C.ClinicCode, '') = '' then NULL
							 ELSE ' (' + C.ClinicCode + ')'
						   END as ClinicName, 
			coalesce(D.signature, D.FirstName + ' ' + D.LastName + D.Suffix) as DictatorName,
			0 as [Jobs Received],
			COUNT(J.JobNumber) as [Jobs Returned],
			(CAST(jed.NumVBC_Job AS DECIMAL(10, 2)) / 65) as [Lines]
	FROM [Entrada].[dbo].Jobs J WITH(NOLOCK)
	JOIN [Entrada].[dbo].Clinics C WITH(NOLOCK) ON 
	     J.ClinicID = C.ClinicID
	JOIN [Entrada].[dbo].Editors_Pay EP WITH(NOLOCK) ON
		 J.EditorID = EP.EditorID
		 AND (EP.PayType = 'ENT' or EP.PayType = 'Intern')
		--AND EP.PayEditorPayRoll = 'Y' --- Left out this line in case Begin & End dates pick up editors that are no longer employed (CA)
	LEFT OUTER JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON
		 J.JobNumber = JED.JobNumber
	JOIN Entrada.dbo.Dictators D ON
		 J.DictatorID = D.DictatorID
	WHERE (J.ReturnedOn BETWEEN dateadd(dd, datediff(dd, 0, @BeginDate)+0, 0)  AND dateadd(dd, datediff(dd, 0, @EndDate)+1, 0)) 
	  AND J.CompletedOn IS NOT NULL
	GROUP BY 
		CONVERT(DATE, J.ReturnedOn, 101), 
		J.ClinicID, 
			C.ClinicName + CASE
							 WHEN ISNULL(C.ClinicCode, '') = '' then NULL
							 ELSE ' (' + C.ClinicCode + ')'
						   END, 
		coalesce(D.signature, D.FirstName + ' ' + D.LastName + D.Suffix),
		(CAST(jed.NumVBC_Job AS DECIMAL(10, 2)) / 65)
	ORDER BY StartDate,
			C.ClinicName + CASE
							 WHEN ISNULL(C.ClinicCode, '') = '' then NULL
							 ELSE ' (' + C.ClinicCode + ')'
						   END, 
		coalesce(D.signature, D.FirstName + ' ' + D.LastName + D.Suffix)


END

GO
