SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Unknown
Create date:	Unknown
Description:	Retrieves editor production data
				for report "Editor Pay And Production - Exportable (TimeParams).rdl"
				
change log:

date		username		description
4/11/13		jablumenthal	This code was embedded in the report.
							I changed it to a stored procedure and 
							then archived it and replaced it with 
							a new procedure that uses the new QA workflow
							tables.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_EditorPayAndProduction_Exportable_TimeParams] 

	@StartDate datetime,
	@EndDate datetime

AS
BEGIN

SET NOCOUNT ON;

		
	SELECT Editors.EditorID, 
		Editors.FirstName, 
		Editors.LastName, 
		T.NumJobs, 
		T.NumChars, 
		T.NumVBC, 
		Editors_Pay.PayLineRate, 
		Editors_Pay.PayEditorPayRoll, 
		Editors_Pay.PayType, 
		Editors_Pay.PayrollCode
	FROM Entrada.dbo.Editors WITH (NOLOCK)
	INNER JOIN (SELECT Jobs.EditorID, 
					COUNT(Jobs.JobNumber) AS NumJobs,
					SUM(EJ.NumChars) as NumChars,
					SUM(EJ.NumVBC) as NumVBC
					/* 
					SUM(Jobs_EditingData.NumChars_Editor) AS NumChars, 
					SUM(Jobs_EditingData.NumVBC_Editor) AS NumVBC
					*/
				FROM  Entrada.dbo.Jobs WITH (NOLOCK)
				JOIN [Entrada].dbo.vwRptEditingJobs EJ WITH (NOLOCK) ON
					 JOBS.JobNumber = EJ.JobNumber
				--INNER JOIN Entrada.dbo.Jobs_EditingData WITH (NOLOCK) ON 
				--	Jobs.JobNumber = Jobs_EditingData.JobNumber
				WHERE (Jobs.ReturnedOn BETWEEN @StartDate AND @EndDate)
				GROUP BY Jobs.EditorID) AS T ON 
		Editors.EditorID = T.EditorID 
	LEFT OUTER JOIN Entrada.dbo.Editors_Pay WITH (NOLOCK) ON 
		Editors.EditorID = Editors_Pay.EditorID
	ORDER BY Editors_Pay.PayEditorPayRoll DESC, 
			 Editors_Pay.PayType, 
			 Editors.LastName
	
END
GO
