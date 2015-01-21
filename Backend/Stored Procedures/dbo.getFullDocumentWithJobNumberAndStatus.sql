USE [Entrada]
GO

/****** Object:  StoredProcedure [dbo].[getFullDocumentWithJobNumberAndStatus]    Script Date: 1/21/2015 3:55:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[getFullDocumentWithJobNumberAndStatus] (
   @JobNumber varchar(20),
   @Status varchar(20),
   @DocID int
)
AS
BEGIN
	SET NOCOUNT ON;
	
	WITH HistoryInfo AS((
	SELECT dbo.Jobs.JobNumber, dbo.Jobs_Documents_History.Status, dbo.Jobs_Documents_History.Doc, 
	       dbo.StatusCodes.StatusName, dbo.StatusCodes.StatusClass, dbo.StatusCodes.StatusStage,
	       dbo.Jobs_Documents_History.Username AS QAName,
	        dbo.Jobs_Documents_History.DocumentID,dbo.Jobs_Documents.Username AS EditorName
	FROM   dbo.Jobs INNER JOIN
						  dbo.Jobs_Documents_History ON dbo.Jobs.JobNumber=dbo.Jobs_Documents_History.JobNumber
						  INNER JOIN
						  dbo.StatusCodes ON dbo.Jobs_Documents_History.Status = dbo.StatusCodes.StatusID
						  INNER JOIN
						  dbo.Jobs_Documents ON dbo.jobs.JobNumber=dbo.Jobs_Documents.JobNumber				  						 						  
	WHERE dbo.jobs.JobNumber = @JobNumber 
)
UNION
(
	SELECT  dbo.jobs.JobNumber,dbo.JobTracking.Status,dbo.Jobs_Documents.Doc,
		dbo.StatusCodes.StatusName, dbo.StatusCodes.StatusClass, dbo.StatusCodes.StatusStage,
		dbo.Jobs_Documents.Username AS QAName, dbo.Jobs_Documents.DocumentId, dbo.jobs.EditorID AS EditorName	
	FROM dbo.Jobs INNER JOIN 
		dbo.Jobs_Documents ON dbo.jobs.JobNumber=dbo.Jobs_Documents.JobNumber
		INNER JOIN dbo.JobTracking ON dbo.JobTracking.JobNumber=dbo.jobs.JobNumber
			and dbo.Jobs.JobStatus=dbo.JobTracking.Status
		 INNER JOIN dbo.StatusCodes ON dbo.jobs.JobStatus = dbo.StatusCodes.StatusID
	 WHERE  dbo.Jobs.JobNumber = @JobNumber AND (dbo.JobTracking.Status IN (100,160,180,210,360,240,250))
	 )
	 )
SELECT * FROM HistoryInfo WHERE Status=@Status and DocumentID=@DocID
END

GO


