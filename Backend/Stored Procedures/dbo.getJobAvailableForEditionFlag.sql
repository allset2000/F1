SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getJobAvailableForEditionFlag] (
   @JobNumber varchar(20)
) AS
   /* Verifies if job status is JobAvailable */
	SELECT CAST((CASE [StatusClass] WHEN 'JobAvailable' THEN 1 ELSE 0 END) AS bit) As AvailableForEdition
	FROM  dbo.vwJobsStatusA
  WHERE ((JobNumber = @JobNumber) AND [StatusStage] IN ('Editor', 'QA', 'QA1', 'QA2')) 
RETURN
GO
