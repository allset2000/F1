
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XX  Entrada Inc
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
--X PROCEDURE: [spv_Get_RhythmJobs]
--X
--X AUTHOR: Naga
--X
--X DESCRIPTION: Stored procedure to get the list of Rhythm Jobs
--X				 
--X
--X ASSUMPTIONS: 
--X
--X DEPENDENTS: 
--X
--X PARAMETERS: 
--X
--X RETURNS:  
--X
--X TABLES REQUIRED: 
--X
--X HISTORY:
--X_____________________________________________________________________________
--X  VER   |    DATE      |  BY						|  COMMENTS - include Ticket#
--X_____________________________________________________________________________
--X   0    | 04/28/2016   | Naga					| Initial Design
--X   1    | 05/20/2016   | Naga					| Fixed the issue with incorrect parathesis in WHERE clause
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
CREATE PROCEDURE [dbo].[spv_Get_RhythmJobs]
				@ProcessFailureCountMax SMALLINT
AS
BEGIN

	SET NOCOUNT ON;

	SELECT j.JobNumber, j.JobId, j.DictatorID, j.DictationDate, j.JobType, j.ClinicID, ja.[Status] AS [JobStatus], j.TemplateName FROM dbo.Jobs j
	INNER JOIN dbo.JobStatusA ja
		ON j.JobNumber = ja.JobNumber
	WHERE ((j.RhythmWorkFlowID = 1 AND j.JobStatus = 138) OR (j.RhythmWorkFlowID = 3 AND j.JobStatus = 275))
		AND ISNULL(j.ProcessFailureCount, 0) < @ProcessFailureCountMax


END
GO
