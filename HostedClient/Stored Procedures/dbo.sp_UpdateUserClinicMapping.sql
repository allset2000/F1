SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 06/09/2015
-- Description: SP used map a clinics to a user
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateUserClinicMapping]
(
	@UserId INT,
	@AddClinics varchar(100),
	@DelClinics varchar(100),
	@ChangedBy varchar(100)
)
AS
BEGIN
	DECLARE @AppPermChange VARCHAR(100)

	SET @AppPermChange = '<User>' + CAST(@UserId as varchar(10)) + '</User><action>Clinics</action>'

	CREATE TABLE #tmp_clinics
	(
		ClinicId INT,
		Processed INT
	)

	INSERT INTO #tmp_clinics (ClinicId, Processed)
	SELECT Value,0 FROM split (@AddClinics, ',')

	-- Add permissions (if exists, update to not deleted)
	WHILE EXISTS (select * from #tmp_clinics where Processed = 0)
	BEGIN
		DECLARE @ClinicId INT
		SET @ClinicId = (select top 1 ClinicId from #tmp_clinics where Processed = 0)

		IF EXISTS (select 1 from UserClinicXref where UserId = @UserId and ClinicId = @ClinicId)
		BEGIN
			UPDATE UserClinicXref SET IsDeleted = 0 WHERE UserId = @UserId and ClinicId = @ClinicId
		END
		ELSE
		BEGIN
			INSERT INTO UserClinicXref(UserId,ClinicId,IsDeleted) VALUES(@UserId,@ClinicId,0)
		END
		UPDATE #tmp_clinics SET Processed = 1 WHERE ClinicId = @ClinicId
	END

	TRUNCATE TABLE #tmp_clinics

	INSERT INTO #tmp_clinics (ClinicId, Processed)
	SELECT Value,0 FROM split (@DelClinics, ',')

	-- Remove permissions
	UPDATE UserClinicXref SET IsDeleted = 1 WHERE UserId = @UserId and ClinicId in (SELECT ClinicId FROM #tmp_clinics)

	DROP TABLE #tmp_clinics

	-- Log the transaction / permission update
	INSERT INTO PermissionChangeTracking(AddPermissions,DelPermissions,AppPermissions,ChangedBy,DateChanged)
	VALUES(@AddClinics,@DelClinics,@AppPermChange,@ChangedBy,GETDATE())

END

GO
