SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryAvailableJobs] (
   @EditorID varchar(50),
   @StatusStage varchar(50)
)
AS

   IF (@StatusStage = 'Editor')
	SELECT *
	FROM   dbo.vwMedicalJobs
    WHERE (([StatusClass] = 'JobAvailable') AND [EditionStage] = 'Editor') AND AssignedToID IN ('', @EditorID)
    ORDER BY AssignedToID DESC, [Stat] DESC, ReceivedOn ASC    
   ELSE 
	SELECT *
	FROM   dbo.vwMedicalJobs
    WHERE (
		  (([StatusClass] = 'JobAvailable') AND [EditionStage] = 'QA' AND [CurrentQAStage] <> 'QA4' AND AssignedToID IN ('', @EditorID))
            AND (dbo.vwMedicalJobs.EditorCompanyId IN (SELECT EditorCompanyId FROM vwEditors WHERE EditorID = @EditorID))
          ) OR (
		  (([StatusClass] = 'JobAvailable') AND [CurrentQAStage] = 'QA4' AND AssignedToID IN ('', @EditorID))
            AND (@EditorID IN (SELECT EditorID FROM vwEditors WHERE EditorCompanyCode = 'ENT'))
		  )
    ORDER BY AssignedToID DESC, [Stat] DESC, ReceivedOn ASC
RETURN
GO
