SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 11/6/2014
-- Description: SP used to pull the rules reasons for Import screen
-- Parameters: UserId: Simply put the UserId of the user to fetch permissions for
--			   ApplicationId: The application for which to pull permissions for
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserModulePermissions] (
	 @UserId int,
	 @ApplicationId int
) AS 
BEGIN

	SELECT A.ApplicationId,
		   A.Description as 'AppDescription',
		   M.ModuleId,
		   M.ModuleName,
		   P.PermissionId,
		   P.Code as 'PermissionCode',
		   P.Name as 'PermissionDescription',
		   R.RoleId,
		   R.RoleName,
		   R.Description as 'RoleDescription',
		   U.UserName
	FROM UserRoleXref URX
		INNER JOIN RolePerMissionXref RPX on RPX.RoleId = URX.RoleId
		INNER JOIN Permissions P on P.PermissionId = RPX.PermissionId
		INNER JOIN Modules M on M.ModuleId = P.ModuleId
		INNER JOIN Applications A on A.ApplicationId = M.ApplicationId
		INNER JOIN Roles R on R.RoleId = RPX.RoleId
		INNER JOIN Users U on U.UserId = URX.UserId
	WHERE URX.UserId = @UserId and A.ApplicationId = @ApplicationId and URX.IsDeleted = 0 and RPX.IsDeleted = 0

END


GO
