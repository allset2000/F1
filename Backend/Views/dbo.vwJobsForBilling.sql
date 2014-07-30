SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwJobsForBilling]
AS
SELECT     dbo.JobEditingSummary.JobId, dbo.Jobs.JobNumber, dbo.Jobs.ClinicID, dbo.Jobs.ReceivedOn, dbo.Jobs.CompletedOn, dbo.Dictators.DictatorIdOk, 
                      dbo.Jobs.DictatorID, dbo.Jobs.Stat, dbo.Jobs.JobType, dbo.JobEditingTasksData.JobEditingTaskId, dbo.JobEditingTasksData.NumPages, 
                      dbo.JobEditingTasksData.NumLines, dbo.JobEditingTasksData.NumChars, dbo.JobEditingTasksData.NumVBC, dbo.JobEditingTasksData.NumCharsPC, 
                      dbo.JobEditingTasksData.BodyWSpaces, dbo.JobEditingTasksData.HeaderFirstWSpaces, dbo.JobEditingTasksData.HeaderPrimaryWSpaces, 
                      dbo.JobEditingTasksData.HeaderEvenWSpaces, dbo.JobEditingTasksData.FooterFirstWSpaces, dbo.JobEditingTasksData.FooterPrimaryWSpaces, 
                      dbo.JobEditingTasksData.FooterEvenWSpaces, dbo.JobEditingTasksData.HeaderTotalWSpaces, dbo.JobEditingTasksData.FooterTotalWSpaces, 
                      dbo.JobEditingTasksData.HeaderFooterTotalWSpaces, dbo.JobEditingTasksData.DocumentWSpaces, dbo.JobEditingTasksData.NumTotalMacros, 
                      dbo.JobEditingTasksData.NumMacrosUnEdited, dbo.JobEditingTasksData.NumMacrosEdited, dbo.JobEditingTasksData.NumCharsUnEditedMacros, 
                      dbo.JobEditingTasksData.NumCharsEditedMacros, dbo.JobEditingTasksData.NumCharsChangedMacros
FROM         dbo.Jobs INNER JOIN
                      dbo.JobEditingSummary ON dbo.Jobs.JobId = dbo.JobEditingSummary.JobId INNER JOIN
                      dbo.JobEditingTasksData ON dbo.JobEditingSummary.BillingEditingTaskId = dbo.JobEditingTasksData.JobEditingTaskId INNER JOIN
                      dbo.Dictators ON dbo.Jobs.DictatorID = dbo.Dictators.DictatorID
WHERE     (dbo.Jobs.CompletedOn IS NOT NULL)
GO
