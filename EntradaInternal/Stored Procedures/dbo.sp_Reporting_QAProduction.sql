SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* ==============================================================
Author:			Charles Arnold
Create date:	3/8/2012
Description:	Retrieves data for report "QA Production.rdl"

change log:
date		username		description
4/30/13		jablumenthal	changed proc to use new QA workflow view
================================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_QAProduction]

	@StartDate DATETIME,
	@EndDate DATETIME


AS
BEGIN
	
	SELECT JQA.EditionMode AS [QA Role], 
			--'QA 1' AS [QA Role],
			JQA.EditedByID AS [QA ID],
			--JQA.EditorID_QA1 AS [QA ID], 
			E.FirstName + ', ' + E.LastName AS [Name],
			EP.PayType, 
			J.EditorID AS [Editor],		
			C.ClinicName AS [Account],
			JQA.JobNumber,
			JQA.ReturnedOn AS [Returned],
			--JQA.ReturnedOn_QA1 AS [Returned],
			JQA.NumChars AS NumChars,
			JQA.NumVBC AS NumVBC,
			(JQA.NumVBC / 65) as Lines
			/*
			JED.NumChars_QA1 AS NumChars, 
			JED.NumVBC_QA1 AS NumVBC,
			(JED.NumVBC_QA1 / 65) AS Lines
			*/
	FROM Entrada.dbo.vwRptActiveQAJobs JQA WITH (NOLOCK)
	--FROM Entrada.dbo.Jobs_QA JQA WITH(NOLOCK)	
	INNER JOIN Entrada.dbo.Jobs J WITH(NOLOCK) ON
		JQA.JobNumber = J.JobNumber
	INNER JOIN Entrada.dbo.Clinics C WITH(NOLOCK) ON
		J.ClinicID = C.ClinicID
	INNER JOIN Entrada.dbo.Editors E WITH (NOLOCK) ON
		JQA.EditedByID = E.EditorID
	LEFT OUTER JOIN Entrada.dbo.Editors_Pay EP WITH (NOLOCK) ON
		JQA.EditedByID = EP.EditorID
	/*
	INNER JOIN Entrada.dbo.Editors E WITH(NOLOCK) ON
		JQA.EditorID_QA1 = E.EditorID		
	LEFT OUTER JOIN Entrada.dbo.Editors_Pay EP WITH(NOLOCK) ON 
		JQA.EditorID_QA1 = EP.EditorID
	INNER JOIN Entrada.dbo.Jobs_EditingData JED WITH(NOLOCK) ON 
		JQA.JobNumber = JED.JobNumber			
	*/
	WHERE (JQA.ReturnedOn BETWEEN DATEADD(dd, DATEDIFF(dd, 0, @StartDate)+0, 0) AND DATEADD(S, -1, DATEADD(dd, DATEDIFF(dd, 0, @EndDate)+1, 0)))  
	  AND JQA.CompletedOn is not null	
	--WHERE (JQA.ReturnedOn_QA1 BETWEEN DATEADD(dd, DATEDIFF(dd, 0, @StartDate)+0, 0)  AND DATEADD(S, -1, DATEADD(dd, DATEDIFF(dd, 0, @EndDate)+1, 0)))

	/*  --no longer need this section with the new QA workflow data
	UNION ALL

	SELECT 'QA 2' AS [QA Role],
		JQA.EditorID_QA2 AS [QA ID], 
		E.FirstName + ', ' + E.LastName AS [Name],
		EP.PayType, 
		J.EditorID AS [Editor],
		C.ClinicName AS [Account],		
		JQA.JobNumber,
		JQA.ReturnedOn_QA2 AS [Returned],
		JED.NumChars_QA2 AS NumChars, 
		JED.NumVBC_QA2 AS NumVBC,
		(JED.NumVBC_QA2 / 65) AS Lines
	FROM Entrada.dbo.Jobs_QA JQA WITH(NOLOCK)
	INNER JOIN Entrada.dbo.Jobs J WITH(NOLOCK) ON
		JQA.JobNumber = J.JobNumber
	INNER JOIN Entrada.dbo.Clinics C WITH(NOLOCK) ON
		J.ClinicID = C.ClinicID
	INNER JOIN Entrada.dbo.Editors E WITH(NOLOCK) ON
		JQA.EditorID_QA2 = E.EditorID
	LEFT OUTER JOIN Entrada.dbo.Editors_Pay EP WITH(NOLOCK) ON 
		JQA.EditorID_QA2 = EP.EditorID
	INNER JOIN Entrada.dbo.Jobs_EditingData JED WITH(NOLOCK) ON 
		JQA.JobNumber = JED.JobNumber			
	WHERE (JQA.ReturnedOn_QA2 BETWEEN DATEADD(dd, DATEDIFF(dd, 0, @StartDate)+0, 0)  AND DATEADD(S, -1, DATEADD(dd, DATEDIFF(dd, 0, @EndDate)+1, 0)))
	*/

	ORDER BY EP.PayType,
			[QA Role],
			[QA ID]	

END


GO
