SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryJobEditingTrack] (
   @JobId int
)
AS
	SELECT *
	FROM   dbo.JobEditingTasks
    WHERE (JobId = @JobId) AND ([TaskStatus] <> 'X')
    ORDER BY JobEditingTaskId
RETURN
GO
