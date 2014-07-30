SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[qryDocumentsToProcess]
AS
SELECT     dbo.Jobs.JobNumber, dbo.Jobs.DictatorID, dbo.Jobs.DictationDate, dbo.Jobs.JobType, dbo.Jobs.ContextName, dbo.Jobs.ClinicID, dbo.Jobs.EditorID, 
                      dbo.Jobs_Patients.MRN
FROM         dbo.Jobs INNER JOIN
                      dbo.DocumentsToProcess ON dbo.Jobs.JobNumber = dbo.DocumentsToProcess.JobNumber INNER JOIN
                      dbo.Jobs_Patients ON dbo.Jobs.JobNumber = dbo.Jobs_Patients.JobNumber
GO
