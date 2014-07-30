SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwContactsRoles]
AS
SELECT        dbo.ContactRoles.ContactRoleId, dbo.ContactRoles.ContactId, dbo.ContactRoles.RoleId, dbo.GeneralObjects.ObjectUniqueKey AS RoleCode, 
                         dbo.GeneralObjects.ObjectName AS RoleName, dbo.ContactRoles.ClinicId, dbo.ContactRoles.ClinicsFilter, dbo.ContactRoles.DictatorsFilter, 
                         dbo.ContactRoles.JobsFilter, dbo.ContactRoles.RoleStatus, ISNULL(dbo.Clinics.ClinicName, '') AS ClinicName, ISNULL(dbo.Clinics.ClinicCode, '') 
                         AS ClinicCode, dbo.Contacts.UserID
FROM            dbo.ContactRoles INNER JOIN
                         dbo.Clinics ON dbo.ContactRoles.ClinicId = dbo.Clinics.ClinicID INNER JOIN
                         dbo.GeneralObjects ON dbo.ContactRoles.RoleId = dbo.GeneralObjects.ObjectId INNER JOIN
                         dbo.Contacts ON dbo.ContactRoles.ContactId = dbo.Contacts.ContactId
WHERE        (NOT (dbo.ContactRoles.RoleStatus IN ('X', 'Y')))

GO
