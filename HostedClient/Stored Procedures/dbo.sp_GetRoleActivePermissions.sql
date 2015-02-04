SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/29/2015
-- Description: SP used to pull the role permissions for a given role and application
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetRoleActivePermissions] (
	 @RoleId int,
	 @ApplicationId int
) AS 
BEGIN

	SELECT P.PermissionId
	FROM RolePermissionXref RPX
		INNER JOIN Permissions P on P.PermissionID = RPX.PermissionId
		INNER JOIN Modules M on M.ModuleId = P.ModuleId
	WHERE RPX.RoleId = @RoleId and M.ApplicationId = @ApplicationId and RPX.IsDeleted = 0

END


GO
