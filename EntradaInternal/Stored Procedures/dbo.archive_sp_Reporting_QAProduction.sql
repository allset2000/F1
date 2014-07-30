SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 3/8/2012
-- Description:	Retrieves data for report 
--		"QA Production.rdl"
-- =============================================
CREATE PROCEDURE [dbo].[archive_sp_Reporting_QAProduction]

	@StartDate DATETIME,
	@EndDate DATETIME

AS
BEGIN
	
   SELECT 'QA 1' AS [QA Role],
		JQA.EditorID_QA1 AS [QA ID], 
		E.FirstName + ', ' + E.LastName AS [Name],
		--EP.PayLineRate, 
		--EP.PayEditorPayRoll, 
		EP.PayType, 
		--EP.PayrollCode,
		J.EditorID AS [Editor],		
		C.ClinicName AS [Account],
		JQA.JobNumber,
		JQA.ReturnedOn_QA1 AS [Returned],
		JED.NumChars_QA1 AS NumChars, 
		JED.NumVBC_QA1 AS NumVBC,
		(JED.NumVBC_QA1 / 65) AS Lines
	FROM Entrada.dbo.Jobs_QA JQA WITH(NOLOCK)	
	INNER JOIN Entrada.dbo.Jobs J WITH(NOLOCK) ON
		JQA.JobNumber = J.JobNumber
	INNER JOIN Entrada.dbo.Clinics C WITH(NOLOCK) ON
		J.ClinicID = C.ClinicID
	INNER JOIN Entrada.dbo.Editors E WITH(NOLOCK) ON
		JQA.EditorID_QA1 = E.EditorID		
	LEFT OUTER JOIN Entrada.dbo.Editors_Pay EP WITH(NOLOCK) ON 
		JQA.EditorID_QA1 = EP.EditorID
	INNER JOIN Entrada.dbo.Jobs_EditingData JED WITH(NOLOCK) ON 
		JQA.JobNumber = JED.JobNumber			
	WHERE (JQA.ReturnedOn_QA1 BETWEEN DATEADD(dd, DATEDIFF(dd, 0, @StartDate)+0, 0)  AND DATEADD(S, -1, DATEADD(dd, DATEDIFF(dd, 0, @EndDate)+1, 0)))
	
	UNION ALL
	
	SELECT 'QA 2' AS [QA Role],
	    JQA.EditorID_QA2 AS [QA ID], 
		E.FirstName + ', ' + E.LastName AS [Name],
		--EP.PayLineRate, 
		--EP.PayEditorPayRoll, 
		EP.PayType, 
		--EP.PayrollCode,
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
	--GROUP BY E.EditorID, 
	--	E.FirstName, 
	--	E.LastName, 
	--	EP.PayLineRate, 
	--	EP.PayEditorPayRoll, 
	--	EP.PayType, 
	--	EP.PayrollCode
	ORDER BY EP.PayType,
		[QA Role],
		[QA ID]	

END

GO
