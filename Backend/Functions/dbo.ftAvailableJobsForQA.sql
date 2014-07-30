SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[ftAvailableJobsForQA] (	
  @EditorID varchar(50)
)
RETURNS TABLE 
AS
RETURN (
	SELECT TOP 100 PERCENT *
	FROM   dbo.vwMedicalJobs
    WHERE (
		  (([StatusClass] = 'JobAvailable') AND [EditionStage] = 'QA' AND [CurrentQAStage] <> 'QA4' AND AssignedToID IN ('', @EditorID))
            AND (dbo.vwMedicalJobs.EditorCompanyId IN (SELECT EditorCompanyId FROM vwEditors WHERE EditorID = @EditorID))
          ) OR (
		  (([StatusClass] = 'JobAvailable') AND [CurrentQAStage] = 'QA4' AND AssignedToID IN ('', @EditorID))
            AND (@EditorID IN (SELECT EditorID FROM vwEditors WHERE EditorCompanyCode = 'ENT'))
		  )
    ORDER BY AssignedToID DESC, [Stat] DESC, ReceivedOn ASC
)
GO
