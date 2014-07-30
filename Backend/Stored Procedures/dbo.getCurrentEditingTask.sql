SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getCurrentEditingTask] (
   @JobId int
) AS
	SELECT *
	FROM   dbo.JobEditingTasks
	WHERE (JobId = @JobId) AND (NextTaskId = -1) AND (TaskStatus <> 'X')
RETURN

GO
