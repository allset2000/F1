SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* ==============================================================
Author:			Charles Arnold
Create date:	3/8/2012
Description:	Retrieves data for report "Jobs From Editors To QA.rdl"

change log:
date		username		description
4/30/13		jablumenthal	changed proc to use new QA workflow view
							the commented out part are the tables/columns
							that were in use in the prior QA workflow
================================================================= */

CREATE PROCEDURE [dbo].[archive_sp_Reporting_JobsFromEditorsToQA_ByClinic]

	@StartDate DATETIME,
	@EndDate DATETIME

AS
BEGIN


	SELECT  C.ClinicName,
			D.LastName + ', ' + D.FirstName AS [Speaker],
			J.JobType,
			E.LastName + ', ' + E.FirstName AS [Editors],
			COUNT(J.JobNumber) AS [Jobs],
			COUNT(JQA.JobNumber) AS [Jobs to QA],
			CAST((CAST(SUM(CASE WHEN JQA.JobNumber IS NOT NULL THEN 1 ELSE 0 END) AS DECIMAL(10,3)) / CAST(COUNT(J.JobNumber)AS DECIMAL(10,3))) * 100  AS DECIMAL(8,1)) AS 'Pct to QA'
	FROM Entrada.dbo.Jobs J WITH(NOLOCK)
	INNER JOIN Entrada.dbo.Clinics C WITH(NOLOCK) ON
		J.ClinicID = C.ClinicID
	INNER JOIN Entrada.dbo.Editors E WITH(NOLOCK) ON
		J.EditorID = E.EditorID
	INNER JOIN Entrada.dbo.Dictators D WITH(NOLOCK) ON
		J.DictatorID = D.DictatorID
	LEFT OUTER JOIN Entrada.dbo.vwRptActiveQAJobs JQA WITH (NOLOCK) ON
		J.JobNumber = JQA.JobNumber
	--LEFT OUTER JOIN Entrada.dbo.Jobs_QA JQA WITH(NOLOCK) ON
	--	J.JobNumber = JQA.JobNumber
	WHERE (J.ReceivedOn BETWEEN DATEADD(dd, DATEDIFF(dd, 0, @StartDate)+0, 0)  AND DATEADD(S, -1, DATEADD(dd, DATEDIFF(dd, 0, @EndDate)+1, 0)))
	GROUP BY C.ClinicName,
			 D.LastName,
			 D.FirstName,
			 J.JobType,
			 E.LastName,
			 E.FirstName
	ORDER BY C.ClinicName,
			 D.LastName,
			 D.FirstName,
			 J.JobType,
			 E.LastName,
			 E.FirstName
			

END

GO
