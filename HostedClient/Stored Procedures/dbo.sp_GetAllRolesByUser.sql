/****** Object:  StoredProcedure [dbo].[sp_GetAllRolesByUser]    Script Date: 8/17/2015 11:36:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Santhosh
-- Create date: 08/06/2015
-- Description: SP used to pull the list of roles for the user
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetAllRolesByUser]
(
	@UserId INT
)
AS
BEGIN	
	IF EXISTS(SELECT 
				URX.RoleID
			FROM UserRoleXref URX	
				INNER JOIN RolePermissionXref RPX ON RPX.RoleId = URX.RoleId
			WHERE URX.UserId = @UserId and URX.IsDeleted = 0 AND RPX.IsDeleted = 0
			AND RPX.PermissionId = (SELECT PermissionID FROM Permissions WHERE Code = 'FNC-ADMINCONSOLE-ACCESS'))
	BEGIN
		SELECT Roles.*, 
		(SELECT COUNT(*) FROM UserRoleXref 
			WHERE Roles.RoleID = UserRoleXref.RoleID) AS UserCount 
		FROM Roles WHERE ClinicId = 0 ORDER BY RoleName
	END
	ELSE
	BEGIN
		SELECT DISTINCT Roles.*, 
		(SELECT COUNT(*) FROM UserRoleXref 
			WHERE Roles.RoleID = UserRoleXref.RoleID) AS UserCount 
		FROM Roles 	
		WHERE ClinicId = 0 
		AND RoleId NOT IN (select RoleId from RolePermissionXref WHERE IsDeleted = 0 AND PermissionId IN
			(select PermissionId from Permissions where ModuleId IN (select ModuleId from Modules WHERE ApplicationId = 5)))
		--AND RoleId NOT IN (select RoleId from RoleApplicationXref WHERE ApplicationId = 5) 
		ORDER BY RoleName
	END	
END
GO


