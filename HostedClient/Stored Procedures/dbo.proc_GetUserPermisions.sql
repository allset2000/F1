-- =============================================
-- Author: Tamojit Chakraborty
-- Create date: 9/21/2015
-- Description: SP Used to get permissions  based on user ID
-- =============================================
CREATE PROCEDURE [dbo].[proc_GetUserPermissions] (
	@userid int,
	@applicationid int
) AS 
BEGIN

		SELECT Distinct P.Code FROM UserRoleXref URX
			INNER JOIN Roles R on R.RoleId = URX.RoleId
			INNER JOIN RolePermissionXref RPX on RPX.RoleId=R.RoleId
			INNER JOIN Permissions P on P.PermissionId=RPX.PermissionId
			INNER JOIN Modules M on M.ModuleId=P.ModuleId
		WHERE URX.UserId = @userid and
			  (	@applicationid is null or M.ApplicationId=@applicationid) and
			  M.IsDeleted=0 and
			  RPX.IsDeleted=0 and
			  URX.IsDeleted=0

END
