SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[ftAvailableJobsForEditor] (	
  @EditorID varchar(50)
)
RETURNS TABLE 
AS
RETURN (
	SELECT TOP 100 PERCENT *
	FROM   dbo.vwMedicalJobs
    WHERE (([StatusClass] = 'JobAvailable') AND [EditionStage] = 'Editor') AND AssignedToID IN ('', @EditorID)
    ORDER BY AssignedToID DESC, [Stat] DESC, ReceivedOn ASC   
)
GO
