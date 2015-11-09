
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 02/20/2015
-- Description: SP used to update the role permissions for a given user (add / del)
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateUserRolePermissions]
(
	@UserId INT,
	@AddPerms varchar(100),
	@DelPerms varchar(100),
	@ChangedBy varchar(100)
)
AS
BEGIN
	DECLARE @AppPermChange VARCHAR(100)

	SET @AppPermChange = '<User>' + CAST(@UserId as varchar(10)) + '</User><action>Roles</action>'

	CREATE TABLE #tmp_perms
	(
		PermissionId INT,
		Processed INT
	)

	INSERT INTO #tmp_perms (PermissionId, Processed)
	SELECT Value,0 FROM split (@AddPerms, ',')

	-- Add permissions (if exists, update to not deleted)
	WHILE EXISTS (select * from #tmp_perms where Processed = 0)
	BEGIN
		DECLARE @PermId INT
		SET @PermId = (select top 1 PermissionId from #tmp_perms where Processed = 0)

		IF EXISTS (select * from UserRoleXref where UserId = @UserId and RoleId = @PermId)
		BEGIN
			UPDATE UserRoleXref SET IsDeleted = 0 WHERE UserId = @UserId and RoleId = @PermId
		END
		ELSE
		BEGIN
			INSERT INTO UserRoleXref(UserId,RoleId,IsDeleted) VALUES(@UserId,@PermId,0)
		END
		UPDATE #tmp_perms SET Processed = 1 WHERE PermissionId = @PermId
	END

	TRUNCATE TABLE #tmp_perms

	INSERT INTO #tmp_perms (PermissionId, Processed)
	SELECT Value,0 FROM split (@DelPerms, ',')

	-- Remove permissions
	UPDATE UserRoleXref SET IsDeleted = 1 WHERE UserId = @UserId and RoleId in (SELECT PermissionId FROM #tmp_perms)

	DROP TABLE #tmp_perms

	-- Log the transaction / permission update
	INSERT INTO PermissionChangeTracking(AddPermissions,DelPermissions,AppPermissions,ChangedBy,DateChanged)
	VALUES(@AddPerms,@DelPerms,@AppPermChange,@ChangedBy,GETDATE())

END

GO
