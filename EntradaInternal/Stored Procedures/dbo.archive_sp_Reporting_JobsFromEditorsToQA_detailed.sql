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
4/30/13		jablumenthal	changed proc to use new QA workflow view;
							QA1 & QA2 are now available at the same time
							the commented out part are the tables/columns
							that were in use in the prior QA workflow
================================================================= */
create PROCEDURE [dbo].[archive_sp_Reporting_JobsFromEditorsToQA_detailed]

	@StartDate DATETIME,
	@EndDate DATETIME

AS
BEGIN
	
	SELECT  J.EditorID AS [Editor],
			E.LastName + ', ' + E.FirstName AS [Name],
			EP.PayType, 
			J.JobNumber AS [Jobs],
			CASE WHEN JQA.EditionMode = 'QA1' THEN 1 ELSE 0 END AS [QA1 Jobs],
			--CASE WHEN JQA.EditorID_QA1 IS NOT NULL THEN 1 ELSE 0 END AS [QA1 Jobs],
			CASE WHEN JQA.EditionMode = 'QA2' THEN 1 ELSE 0 END AS [QA2 Jobs],
			--0 AS [QA2 Jobs],
			CL.ClinicName,
			DI.FirstName+' '+DI.LastName
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
	--	JQA.EditorID_QA1 = QA1.EditorID
	INNER JOIN Entrada.dbo.Clinics CL WITH(NOLOCK) ON
		J.ClinicID = CL.ClinicID
	INNER JOIN Entrada.dbo.Dictators DI WITH(NOLOCK) ON
		J.DictatorID = DI.DictatorID
	WHERE (J.ReceivedOn BETWEEN DATEADD(dd, DATEDIFF(dd, 0, '2012-10-01')+0, 0) AND DATEADD(S, -1, DATEADD(dd, DATEDIFF(dd, 0, '2012-10-10')+1, 0)))

	--UNION ALL

	--SELECT  JQA.EditorID_QA1 AS [Editor],
	--		E.LastName + ', ' + E.FirstName AS [Name],
	--		EP.PayType, 
	--		J.JobNumber AS [Jobs],
	--		0 AS [QA1 Jobs],
	--		CASE WHEN JQA.EditorID_QA2 IS NOT NULL THEN 1 ELSE 0 END AS [QA2 Jobs],
	--		CL.ClinicName,
	--		DI.FirstName+' '+DI.LastName
	--FROM Entrada.dbo.Jobs J WITH(NOLOCK)	
	--LEFT OUTER JOIN Entrada.dbo.Jobs_QA JQA WITH(NOLOCK) ON
	--	J.JobNumber = JQA.JobNumber
	--INNER JOIN Entrada.dbo.Editors E WITH(NOLOCK) ON
	--	JQA.EditorID_QA1 = E.EditorID		
	--INNER JOIN Entrada.dbo.Editors_Pay EP WITH(NOLOCK) ON 
	--	JQA.EditorID_QA1= EP.EditorID
	--LEFT OUTER JOIN Entrada.dbo.Jobs_EditingData JED WITH(NOLOCK) ON 
	--	J.JobNumber = JED.JobNumber	
	--LEFT OUTER JOIN Entrada.dbo.Editors_Pay QA1 WITH(NOLOCK) ON
	--	JQA.EditorID_QA1 = QA1.EditorID
	--INNER JOIN Entrada.dbo.Clinics CL WITH(NOLOCK) ON
	--	J.ClinicID=CL.ClinicID
	--INNER JOIN Entrada.dbo.Dictators DI WITH(NOLOCK) ON
	--	J.DictatorID=DI.DictatorID
	--WHERE (J.ReceivedOn BETWEEN DATEADD(dd, DATEDIFF(dd, 0, '2012-10-01')+0, 0) AND DATEADD(S, -1, DATEADD(dd, DATEDIFF(dd, 0, '2012-10-10')+1, 0)))
	
	ORDER BY Jobs
	

END

GO
