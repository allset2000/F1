SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ZZZvwRptEditingJobs1]
AS
SELECT     JobEditingSummary.JobId, Jobs.JobNumber, JobEditingTasksData.JobEditingTaskId, Jobs.DictatorID, Jobs.ClinicID, JobEditingTasks.AssignedToID AS EditedByID, 
                      vwWorkflowStates.StateCode AS EditionMode, CASE WHEN BillingEditingTaskId = JobEditingTasks.JobEditingTaskId THEN 1 ELSE 0 END AS UseForBilling, JobEditingTasks.ReceivedOn, 
                      JobEditingTasks.ReturnedOn, Jobs.CompletedOn, JobEditingTasksData.NumPages, JobEditingTasksData.NumLines, JobEditingTasksData.NumChars, JobEditingTasksData.NumVBC, 
                      JobEditingTasksData.NumCharsPC, JobEditingTasksData.BodyWSpaces, JobEditingTasksData.HeaderFirstWSpaces, JobEditingTasksData.HeaderPrimaryWSpaces, 
                      JobEditingTasksData.HeaderEvenWSpaces, JobEditingTasksData.FooterFirstWSpaces, JobEditingTasksData.FooterPrimaryWSpaces, JobEditingTasksData.FooterEvenWSpaces, 
                      JobEditingTasksData.HeaderTotalWSpaces, JobEditingTasksData.FooterTotalWSpaces, JobEditingTasksData.HeaderFooterTotalWSpaces, JobEditingTasksData.DocumentWSpaces, 
                      Jobs.ReturnedOn AS JobsReturnedOn
FROM         JobEditingTasks INNER JOIN
                      JobEditingSummary ON JobEditingTasks.JobId = JobEditingSummary.JobId INNER JOIN
                      JobEditingTasksData ON JobEditingTasks.JobEditingTaskId = JobEditingTasksData.JobEditingTaskId INNER JOIN
                      Jobs ON JobEditingSummary.JobId = Jobs.JobId INNER JOIN
                      vwWorkflowStates ON JobEditingTasks.CurrentStateId = vwWorkflowStates.WorkflowStateId
GO
