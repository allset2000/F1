SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 06/09/2015
-- Description: SP used map providers to a user
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateUserProviderMapping]
(
	@UserId INT,
	@AddProv varchar(100),
	@DelProv varchar(100),
	@ChangedBy varchar(100)
)
AS
BEGIN
	DECLARE @AppPermChange VARCHAR(100)

	SET @AppPermChange = '<User>' + CAST(@UserId as varchar(10)) + '</User><action>Providers</action>'

	CREATE TABLE #tmp_providers
	(
		DictatorId INT,
		Processed INT
	)

	INSERT INTO #tmp_providers (DictatorId, Processed)
	SELECT Value,0 FROM split (@AddProv, ',')

	-- Add permissions (if exists, update to not deleted)
	WHILE EXISTS (select * from #tmp_providers where Processed = 0)
	BEGIN
		DECLARE @ProviderId INT
		SET @ProviderId = (select top 1 DictatorId from #tmp_providers where Processed = 0)

		IF EXISTS (select 1 from PortalUserDictatorXref where UserId = @UserId and DictatorId = @ProviderId)
		BEGIN
			UPDATE PortalUserDictatorXref SET IsDeleted = 0 WHERE UserId = @UserId and DictatorId = @ProviderId
		END
		ELSE
		BEGIN
			INSERT INTO PortalUserDictatorXref(UserId,DictatorId,IsDeleted) VALUES(@UserId,@ProviderId,0)
		END
		UPDATE #tmp_providers SET Processed = 1 WHERE DictatorId = @ProviderId
	END

	TRUNCATE TABLE #tmp_providers

	INSERT INTO #tmp_providers (DictatorId, Processed)
	SELECT Value,0 FROM split (@DelProv, ',')

	-- Remove permissions
	UPDATE PortalUserDictatorXref SET IsDeleted = 1 WHERE UserId = @UserId and DictatorId in (SELECT DictatorId FROM #tmp_providers)

	DROP TABLE #tmp_providers

	-- Log the transaction / permission update
	INSERT INTO PermissionChangeTracking(AddPermissions,DelPermissions,AppPermissions,ChangedBy,DateChanged)
	VALUES(@AddProv,@DelProv,@AppPermChange,@ChangedBy,GETDATE())

END

GO
