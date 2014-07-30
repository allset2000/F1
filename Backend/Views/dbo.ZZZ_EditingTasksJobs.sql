SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[ZZZ_EditingTasksJobs]
AS
SELECT DISTINCT TOP (100) PERCENT dbo.JobEditingTasks.JobId, dbo.JobStatusA.Status
FROM         dbo.Jobs INNER JOIN
                      dbo.JobStatusA ON dbo.Jobs.JobNumber = dbo.JobStatusA.JobNumber INNER JOIN
                      dbo.JobEditingTasks ON dbo.Jobs.JobId = dbo.JobEditingTasks.JobId
ORDER BY dbo.JobStatusA.Status

GO
