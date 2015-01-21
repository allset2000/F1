SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryJobTracking] (
   @JobNumber varchar(20)
) AS
	SELECT dbo.JobTracking.JobNumber, dbo.JobTracking.Status , dbo.JobTracking.StatusDate , 
			dbo.JobTracking.Path, dbo.StatusCodes.StatusName, dbo.StatusCodes.StatusClass, 
			dbo.StatusCodes.StatusStage, dbo.Jobs_Documents_History.Username AS QAName,
			dbo.Jobs_Documents_History.DocumentID ,dbo.Jobs_Documents.Username AS EditorName,
			dbo.Jobs_Documents_History.Doc
	FROM   dbo.JobTracking INNER JOIN
						  dbo.StatusCodes ON dbo.JobTracking.Status = dbo.StatusCodes.StatusID
						  INNER JOIN
						  dbo.Jobs_Documents ON dbo.JobTracking.JobNumber=dbo.Jobs_Documents.JobNumber						  
						  LEFT OUTER JOIN
						  dbo.Jobs_Documents_History ON dbo.JobTracking.JobNumber=dbo.Jobs_Documents_History.JobNumber 
						  AND dbo.JobTracking.Status= dbo.Jobs_Documents_History.Status	
						  AND dbo.JobTracking.StatusDate	=dbo.Jobs_Documents_History.StatusDate					 						  
	WHERE (dbo.JobTracking.JobNumber = @JobNumber) AND (dbo.JobTracking.Status in(100,160,180,210,360,240,250))
	ORDER BY dbo.JobTracking.Status, dbo.JobTracking.StatusDate
RETURN
GO
