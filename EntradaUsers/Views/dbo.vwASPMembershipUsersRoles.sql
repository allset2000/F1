SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwASPMembershipUsersRoles]
AS
SELECT     dbo.aspnet_Membership.UserId, dbo.aspnet_Users.UserName, ISNULL(dbo.aspnet_Membership.Email, N'') AS Email, dbo.aspnet_Roles.RoleName, 
                      ISNULL(dbo.aspnet_Membership.Comment, N'') AS ClinicName, dbo.UserIDMapping.UserIdOk
FROM         dbo.aspnet_Users INNER JOIN
                      dbo.aspnet_UsersInRoles ON dbo.aspnet_Users.UserId = dbo.aspnet_UsersInRoles.UserId INNER JOIN
                      dbo.aspnet_Roles ON dbo.aspnet_UsersInRoles.RoleId = dbo.aspnet_Roles.RoleId INNER JOIN
                      dbo.aspnet_Membership ON dbo.aspnet_Users.UserId = dbo.aspnet_Membership.UserId INNER JOIN
                      dbo.UserIDMapping ON dbo.aspnet_Membership.UserId = dbo.UserIDMapping.UserId



GO
