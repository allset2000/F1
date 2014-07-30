SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*=======================================================
Author:			Charles Arnold
Create date:	4/6/2012
Description:	Retrieves outstanding jobs 
				for report "Documents to Process.rdl"

change log
date		username		description
5/23/13		jablumenthal	changed the threshold to 200
							per request from Justin Steidinger

6/17/14		iswindle		changed the threshold to 400
							per request from Juston Steidinger
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_DocumentsToProcess]

	@Monitor int

AS


BEGIN
	
	DECLARE @Recs bigint


	SELECT @Recs = COUNT(Jobs.JobNumber)
	FROM [Entrada].[dbo].Jobs 
	INNER JOIN [Entrada].[dbo].DocumentsToProcess ON 
		Jobs.JobNumber = DocumentsToProcess.JobNumber 
	INNER JOIN [Entrada].[dbo].Jobs_Patients ON 
		Jobs.JobNumber = Jobs_Patients.JobNumber

	
	IF @Recs < 400 AND @Monitor = 1
		BEGIN
			SELECT 1/0
		END
	ELSE
		BEGIN
			SELECT Jobs.JobNumber, 
				Jobs.DictatorID, 
				Jobs.DictationDate, 
				Jobs.JobType, 
				Jobs.ContextName, 
				Jobs.ClinicID, 
				Jobs.EditorID, 
				Jobs_Patients.MRN,
				DATEDIFF(DAY, Jobs.DictationDate, GETDATE()) AS [Elapsed Days]
			FROM [Entrada].[dbo].Jobs 
			INNER JOIN [Entrada].[dbo].DocumentsToProcess ON 
				Jobs.JobNumber = DocumentsToProcess.JobNumber 
			INNER JOIN [Entrada].[dbo].Jobs_Patients ON 
				Jobs.JobNumber = Jobs_Patients.JobNumber
			ORDER BY DictationDate
		END		
END	


GO
