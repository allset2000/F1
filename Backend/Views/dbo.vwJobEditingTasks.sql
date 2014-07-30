SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwJobEditingTasks]
AS
SELECT     dbo.JobEditingTasks.JobEditingTaskId, dbo.JobEditingTasks.JobId, dbo.JobEditingTasks.AssignedToID, dbo.JobEditingTasks.EditionNote, 
                      dbo.JobEditingTasks.QACategoryId, dbo.vwQACategories.QACategory, dbo.JobEditingTasks.CurrentStateId, dbo.JobEditingTasks.NextStateId, 
                      dbo.JobEditingTasks.WorkflowRuleId, dbo.JobEditingTasks.AssignmentMode, dbo.JobEditingTasks.AssignedById, dbo.JobEditingTasks.ReleasedById, 
                      dbo.JobEditingTasks.AssignedOn, dbo.JobEditingTasks.ReceivedOn, dbo.JobEditingTasks.ReturnedOn, dbo.JobEditingTasks.PreviousTaskId, 
                      dbo.JobEditingTasks.NextTaskId, dbo.JobEditingTasks.TaskStatus, dbo.vwWorkflowStates.EditionStage, dbo.vwWorkflowStates.StateCode AS EditionStageStep, 
                      vwWorkflowStates_1.StateCode AS NextState, 
                      CASE dbo.JobEditingTasks.AssignedToID WHEN '' THEN JobEditingTasks_1.AssignedToID ELSE dbo.JobEditingTasks.AssignedToID END AS LastAssignedToID, 
                      CASE dbo.JobEditingTasks.EditionNote WHEN '' THEN JobEditingTasks_1.EditionNote ELSE dbo.JobEditingTasks.EditionNote END AS LastNote
FROM         dbo.JobEditingTasks INNER JOIN
                      dbo.vwWorkflowStates ON dbo.JobEditingTasks.CurrentStateId = dbo.vwWorkflowStates.WorkflowStateId INNER JOIN
                      dbo.vwWorkflowStates AS vwWorkflowStates_1 ON dbo.JobEditingTasks.NextStateId = vwWorkflowStates_1.WorkflowStateId INNER JOIN
                      dbo.vwQACategories ON dbo.JobEditingTasks.QACategoryId = dbo.vwQACategories.QACategoryId INNER JOIN
                      dbo.JobEditingTasks AS JobEditingTasks_1 ON dbo.JobEditingTasks.PreviousTaskId = JobEditingTasks_1.JobEditingTaskId
GO
