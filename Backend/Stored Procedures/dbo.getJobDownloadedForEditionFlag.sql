SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getJobDownloadedForEditionFlag] (
   @JobNumber varchar(20)
) AS
  
   /* Verify if job status is JobDownloaded */
	SELECT CAST((CASE [StatusClass] WHEN 'JobDownloaded' THEN 1 ELSE 0 END) AS bit)
	FROM  dbo.vwJobsStatusA
	WHERE (JobNumber = @JobNumber)
RETURN
GO
