SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwJobsEditingTasksData]
AS
SELECT     dbo.Jobs.JobNumber, dbo.vwJobEditingTasks.EditionStage, dbo.Jobs.ReceivedOn, dbo.Jobs.ReturnedOn, dbo.Jobs.CompletedOn, 
                      dbo.vwJobEditingTasks.AssignedToID, dbo.JobEditingTasksData.JobEditingTaskId, dbo.JobEditingTasksData.NumPages, dbo.JobEditingTasksData.NumLines, 
                      dbo.JobEditingTasksData.NumChars, dbo.JobEditingTasksData.NumVBC, dbo.JobEditingTasksData.NumCharsPC, dbo.JobEditingTasksData.BodyWSpaces, 
                      dbo.JobEditingTasksData.HeaderFirstWSpaces, dbo.JobEditingTasksData.HeaderPrimaryWSpaces, dbo.JobEditingTasksData.HeaderEvenWSpaces, 
                      dbo.JobEditingTasksData.FooterFirstWSpaces, dbo.JobEditingTasksData.FooterPrimaryWSpaces, dbo.JobEditingTasksData.FooterEvenWSpaces, 
                      dbo.JobEditingTasksData.HeaderTotalWSpaces, dbo.JobEditingTasksData.FooterTotalWSpaces, dbo.JobEditingTasksData.HeaderFooterTotalWSpaces, 
                      dbo.JobEditingTasksData.DocumentWSpaces
FROM         dbo.Jobs INNER JOIN
                      dbo.vwJobEditingTasks ON dbo.Jobs.JobId = dbo.vwJobEditingTasks.JobId INNER JOIN
                      dbo.JobEditingTasksData ON dbo.vwJobEditingTasks.JobEditingTaskId = dbo.JobEditingTasksData.JobEditingTaskId
WHERE     (dbo.vwJobEditingTasks.TaskStatus IN ('C', 'F'))
GO
