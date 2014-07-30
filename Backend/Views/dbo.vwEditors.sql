SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vwEditors]
AS
SELECT     dbo.Editors.EditorIdOk, dbo.Editors.EditorID, dbo.Editors.EditorPwd, dbo.Editors.JobCount, dbo.Editors.JobMax, dbo.Editors.JobStat, dbo.Editors.AutoDownload, 
                      dbo.Editors.Managed, dbo.Editors.ManagedBy, dbo.Editors.ClinicID, dbo.Editors.EnableAudit, dbo.Editors.SignOff1, dbo.Editors.SignOff2, dbo.Editors.SignOff3, 
                      dbo.Editors.RoleID, dbo.Editors.FirstName, dbo.Editors.LastName, dbo.Editors.MI, dbo.Editors.EditorEMail, dbo.Editors.Type, 
                      CASE [Type] WHEN 10 THEN 'Editor' WHEN 20 THEN 'QA' ELSE 'Editor' END AS EditorType, dbo.Editors.IdleTime, dbo.Editors.EditorCompanyId, 
                      dbo.Companies.CompanyCode AS EditorCompanyCode, dbo.Companies.EditingWorkflowModelId, ISNULL(dbo.vwQueueWorkspaceEditors.QueueWorkspaceId, - 1) 
                      AS EditingWorkspaceId, dbo.Editors.EditorQAIDMatch, dbo.Contacts.ContactStatus AS EditorStatus
FROM         dbo.Editors INNER JOIN
                      dbo.Companies ON dbo.Editors.EditorCompanyId = dbo.Companies.CompanyId INNER JOIN
                      dbo.Contacts ON dbo.Editors.EditorIdOk = dbo.Contacts.ContactId AND dbo.Editors.EditorID = dbo.Contacts.UserID LEFT OUTER JOIN
                      dbo.vwQueueWorkspaceEditors ON dbo.Editors.EditorIdOk = dbo.vwQueueWorkspaceEditors.EditorId
WHERE     (dbo.Contacts.ContactType = 'E')
GO
