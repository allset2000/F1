SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryDocumentHistory] (
   @JobNumber varchar(20)
) AS

SELECT * FROM (
	SELECT Jobs_Documents.JobNumber, Username, DocDate
	FROM   dbo.Jobs_Documents INNER JOIN dbo.Jobs
	ON dbo.Jobs_Documents.JobNumber = dbo.Jobs.JobNumber
    WHERE (dbo.Jobs.JobNumber = @JobNumber) AND (DocDate >= dbo.Jobs.CompletedOn) AND
	      (dbo.Jobs.CompletedOn IS NOT NULL) 
UNION		  
	SELECT Jobs_Documents_History.JobNumber, Username, DocDate
	FROM   dbo.Jobs_Documents_History INNER JOIN dbo.Jobs
	ON dbo.Jobs_Documents_History.JobNumber = dbo.Jobs.JobNumber
    WHERE (dbo.Jobs.JobNumber = @JobNumber) AND (DocDate >= dbo.Jobs.CompletedOn) AND
	      (dbo.Jobs.CompletedOn IS NOT NULL)
) Documents 
ORDER BY DocDate DESC 
RETURN

GO
