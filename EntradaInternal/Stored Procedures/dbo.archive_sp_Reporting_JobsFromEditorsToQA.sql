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
create PROCEDURE [dbo].[archive_sp_Reporting_JobsFromEditorsToQA]

	@StartDate DATETIME,
	@EndDate DATETIME

AS
BEGIN
	
	SELECT  J.EditorID AS [Editor],
			E.LastName + ', ' + E.FirstName AS [Name],
			EP.PayType, 
			J.DictatorID,
			COUNT(J.JobNumber) AS [Jobs],
			SUM(CASE WHEN JQA.EditionMode = 'QA1' THEN 1 ELSE 0 END) AS [QA1 Jobs],
			--SUM(CASE WHEN JQA.EditorID_QA1 IS NOT NULL THEN 1 ELSE 0 END) AS [QA1 Jobs],
			SUM(CASE WHEN JQA.JobNumber IS NOT NULL THEN 1 ELSE 0 END) AS [QA Jobs],
			CAST((CAST(SUM(CASE WHEN JQA.JobNumber IS NOT NULL THEN 1 ELSE 0 END) AS DECIMAL(10,3)) / CAST(COUNT(J.JobNumber)AS DECIMAL(10,3))) * 100  AS DECIMAL(8,1)) AS [Pct Complete],
			CAST((CAST(SUM(CASE WHEN JQA.EditionMode = 'QA1' THEN 1 ELSE 0 END) AS DECIMAL(10,3)) / CAST(COUNT(J.JobNumber)AS DECIMAL(10,3))) * 100  AS DECIMAL(8,1)) AS [pct QA1]
			--CAST((CAST(SUM(CASE WHEN JQA.EditorID_QA1 IS NOT NULL THEN 1 ELSE 0 END) AS DECIMAL(10,3)) / CAST(COUNT(J.JobNumber)AS DECIMAL(10,3))) * 100  AS DECIMAL(8,1)) AS [pct QA1]
	FROM Entrada.dbo.Jobs J WITH(NOLOCK)
	LEFT OUTER JOIN Entrada.dbo.vwRptActiveQAJobs JQA WITH (NOLOCK) ON
		J.JobNumber = JQA.JobNumber	
	--LEFT OUTER JOIN Entrada.dbo.Jobs_QA JQA WITH(NOLOCK) ON
	--	J.JobNumber = JQA.JobNumber
	INNER JOIN Entrada.dbo.Editors E WITH(NOLOCK) ON
		J.EditorID = E.EditorID		
	INNER JOIN Entrada.dbo.Editors_Pay EP WITH(NOLOCK) ON 
		E.EditorID = EP.EditorID
	--LEFT OUTER JOIN Entrada.dbo.Jobs_EditingData JED WITH(NOLOCK) ON 
	--	J.JobNumber = JED.JobNumber	
	--LEFT OUTER JOIN Entrada.dbo.Editors_Pay QA1 WITH(NOLOCK) ON
		--JQA.EditorID_QA1 = QA1.EditorID
	WHERE (J.ReceivedOn BETWEEN DATEADD(dd, DATEDIFF(dd, 0, @StartDate)+0, 0)  AND DATEADD(S, -1, DATEADD(dd, DATEDIFF(dd, 0, @EndDate)+1, 0)))
	GROUP BY J.EditorID,
			 E.LastName,
			 E.FirstName,
			 EP.PayType,
			 J.DictatorID
	ORDER BY [Name]

END

GO
