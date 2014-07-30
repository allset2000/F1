SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryJobTracking] (
   @JobNumber varchar(20)
) AS
	SELECT dbo.JobTracking.JobNumber, MIN(dbo.JobTracking.Status) AS Status, MAX(dbo.JobTracking.StatusDate) AS StatusDate, 
	       MAX(dbo.JobTracking.Path) AS Path, 
	       dbo.StatusCodes.StatusName, dbo.StatusCodes.StatusClass, dbo.StatusCodes.StatusStage
	FROM   dbo.JobTracking INNER JOIN
						  dbo.StatusCodes ON dbo.JobTracking.Status = dbo.StatusCodes.StatusID
	WHERE (JobNumber = @JobNumber) AND (dbo.JobTracking.Status in(100, 160, 250, 260))
	GROUP BY dbo.JobTracking.JobNumber, dbo.JobTracking.Status, dbo.StatusCodes.StatusName, dbo.StatusCodes.StatusClass, dbo.StatusCodes.StatusStage
RETURN
GO
