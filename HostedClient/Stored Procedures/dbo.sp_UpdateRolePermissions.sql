
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 01/29/2015
-- Description: SP used to return a list of users tied to a list of dictators
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateRolePermissions]
(
	@RoleId INT,
	@AddPerms varchar(1000),
	@DelPerms varchar(1000),
	@MobilePerm bit,
	@ACPerm bit,
	@CustomerPortalPerm bit,
	@ChangedBy varchar(100)
)
AS
BEGIN
	DECLARE @AppPermChange VARCHAR(100)

	SET @AppPermChange = '<Mobile>' + CAST(@MobilePerm as varchar(1)) + '</Mobile><AC>' + CAST(@ACPerm as varchar(1)) + '</AC>'

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

		IF EXISTS (select * from RolePermissionXref where RoleId = @RoleId and PermissionId = @PermId)
		BEGIN
			UPDATE RolePermissionXref SET IsDeleted = 0 WHERE RoleId = @RoleId and PermissionId = @PermId
		END
		ELSE
		BEGIN
			INSERT INTO RolePermissionXref(RoleId,PermissionId,IsDeleted) VALUES(@RoleId,@PermId,0)
		END
		UPDATE #tmp_perms SET Processed = 1 WHERE PermissionId = @PermId
	END

	TRUNCATE TABLE #tmp_perms

	INSERT INTO #tmp_perms (PermissionId, Processed)
	SELECT Value,0 FROM split (@DelPerms, ',')

	-- Remove permissions
	UPDATE RolePermissionXref SET IsDeleted = 1 WHERE RoleId = @RoleId and PermissionId in (SELECT PermissionId FROM #tmp_perms)

	DROP TABLE #tmp_perms

	-- Flip values, AC sends true if checked, true in this case means deleted
	IF (@MobilePerm = 1) BEGIN SET @MobilePerm = 0 END ELSE BEGIN SET @MobilePerm = 1 END
	IF (@ACPerm = 1) BEGIN SET @ACPerm = 0 END ELSE BEGIN SET @ACPerm = 1 END
	IF (@CustomerPortalPerm = 1) BEGIN SET @CustomerPortalPerm = 0 END ELSE BEGIN SET @CustomerPortalPerm = 1 END

	-- Check / Update permissions to Mobile App
	IF EXISTS (select 1 from RoleApplicationXref where RoleId = @RoleId and ApplicationId = 4) -- Mobile
	BEGIN
		UPDATE RoleApplicationXref SET IsDeleted = @MobilePerm WHERE RoleId = @RoleId and ApplicationId = 4
	END
	ELSE
	BEGIN
		IF (@MobilePerm = 0)
		BEGIN
			INSERT INTO RoleApplicationXref(RoleId,ApplicationId,IsDeleted) VALUES(@RoleId, 4, 0)
		END	
	END

	-- Check / Update permissions to Admin Console
	IF EXISTS (select 1 from RoleApplicationXref where RoleId = @RoleId and ApplicationId = 5) -- AC
	BEGIN
		UPDATE RoleApplicationXref SET IsDeleted = @ACPerm WHERE RoleId = @RoleId and ApplicationId = 5
	END
	ELSE
	BEGIN
		IF (@ACPerm  = 0)
		BEGIN
			INSERT INTO RoleApplicationXref(RoleId,ApplicationId,IsDeleted) VALUES(@RoleId, 5, 0)
		END	
	END

	-- Check / Update permissions to Customer Portal
	IF EXISTS (select 1 from RoleApplicationXref where RoleId = @RoleId and ApplicationId = 6) -- AC
	BEGIN
		UPDATE RoleApplicationXref SET IsDeleted = @CustomerPortalPerm WHERE RoleId = @RoleId and ApplicationId = 6
	END
	ELSE
	BEGIN
		IF (@CustomerPortalPerm = 0)
		BEGIN
			INSERT INTO RoleApplicationXref(RoleId,ApplicationId,IsDeleted) VALUES(@RoleId, 6, 0)
		END	
	END

	-- Log the transaction / permission update
	INSERT INTO PermissionChangeTracking(AddPermissions,DelPermissions,AppPermissions,ChangedBy,DateChanged)
	VALUES(@AddPerms,@DelPerms,@AppPermChange,@ChangedBy,GETDATE())

END


GO
