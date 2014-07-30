SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Charles Arnold
Create date:	3/8/2012
Description:	Retrieves editor production data
				for report "Editor Pay And Production - Exportable.rdl"
				
change log

date		username		description
4/11/13		jablumenthal	updated stored proc to use new tables.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_EditorPayAndProduction]

	@StartDate DATETIME,
	@EndDate DATETIME

AS
BEGIN
	
	SELECT  E.EditorID, 
			E.FirstName, 
			E.LastName, 
			EP.PayLineRate, 
			EP.PayEditorPayRoll, 
			EP.PayType, 
			EP.PayrollCode,
			COUNT(J.JobNumber) AS NumJobs, 
			SUM(EJ.NumChars) as NumChars,
			SUM(EJ.NumVBC) as NumVBC,
			/*
			SUM(JED.NumChars_Editor) AS NumChars, 
			SUM(JED.NumVBC_Editor) AS NumVBC,
			*/
			SUM(CASE
					WHEN (S.Confidence / 10) < 85 THEN 1
					ELSE 0
				END) AS Confidence		
	FROM Entrada.dbo.Editors E WITH(NOLOCK)
	JOIN Entrada.dbo.Jobs J WITH(NOLOCK) ON
		 E.EditorID = J.EditorID
	JOIN Entrada.dbo.[Stats] S WITH(NOLOCK) ON
		 J.JobNumber = S.Job
	JOIN [Entrada].dbo.vwRptEditingJobs EJ WITH (NOLOCK) ON
		 J.JobNumber = EJ.JobNumber
	--JOIN Entrada.dbo.Jobs_EditingData JED WITH(NOLOCK) ON 
	--	 J.JobNumber = JED.JobNumber		
	LEFT OUTER JOIN Entrada.dbo.Editors_Pay EP WITH(NOLOCK) ON 
		 E.EditorID = EP.EditorID
	WHERE (J.ReturnedOn BETWEEN DATEADD(dd, DATEDIFF(dd, 0, @StartDate)+0, 0)  AND DATEADD(S, -1, DATEADD(dd, DATEDIFF(dd, 0, @EndDate)+1, 0)))
	GROUP BY E.EditorID, 
		E.FirstName, 
		E.LastName, 
		EP.PayLineRate, 
		EP.PayEditorPayRoll, 
		EP.PayType, 
		EP.PayrollCode
	ORDER BY EP.PayEditorPayRoll DESC, 
		EP.PayType, 
		E.LastName		

END
GO
