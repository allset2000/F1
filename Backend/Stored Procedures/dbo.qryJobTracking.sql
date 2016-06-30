
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryJobTracking] (
   @JobNumber varchar(20)
) AS
	SELECT dbo.JobTracking.JobNumber, dbo.JobTracking.Status , dbo.JobTracking.StatusDate , 
			dbo.JobTracking.Path, dbo.StatusCodes.StatusName, dbo.StatusCodes.StatusClass, 
			dbo.StatusCodes.StatusStage, JDHH.Username AS QAName,
			JDHH.DocumentID ,dbo.Jobs_Documents.Username AS EditorName,
			JDHH.Doc
	FROM   dbo.JobTracking INNER JOIN
						  dbo.StatusCodes ON dbo.JobTracking.Status = dbo.StatusCodes.StatusID
						  INNER JOIN
						  dbo.Jobs_Documents ON dbo.JobTracking.JobNumber=dbo.Jobs_Documents.JobNumber						  
						  OUTER APPLY (SELECT TOP 1 Username, DocumentID, Doc from dbo.Jobs_Documents_History JDH 
						  WHERE dbo.JobTracking.JobNumber= JDH.JobNumber 
						  AND dbo.JobTracking.Status= JDH.Status	
						  --AND dbo.JobTracking.StatusDate = JDH.StatusDate 
						  ORDER BY JDH.DocDate ASC) JDHH		 						  
	WHERE (dbo.JobTracking.JobNumber = @JobNumber) AND (dbo.JobTracking.Status in(100,160,180,210,360,240,250))
	ORDER BY dbo.JobTracking.Status, dbo.JobTracking.StatusDate
RETURN

GO
