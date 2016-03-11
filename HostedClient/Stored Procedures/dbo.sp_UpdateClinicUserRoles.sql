SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/24/2015
-- Description: SP used to add a role to all users mapped to a clinic
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateClinicUserRoles] (
	@ClinicId int,
	@RoleId int,
	@Action int
) AS 
BEGIN

	CREATE TABLE #users
	(
		UserId int,
		Processed int
	)
	
	INSERT INTO #users (UserId, Processed)
	SELECT DISTINCT(UserId), 0 from Dictators where UserId is not null AND ClinicID = @ClinicId

	WHILE EXISTS (select 1 from #users where Processed = 0)
	BEGIN
		DECLARE @cur_userid int
		set @cur_userid = (select top 1 UserId from #users where Processed = 0)

		IF (@Action = 0) -- Add permission
		BEGIN
			IF NOT EXISTS (select 1 from UserRoleXref where UserId = @cur_userid and RoleId = @RoleId)
			BEGIN
				INSERT INTO UserRoleXref(UserId,RoleId,IsDeleted) VALUES(@cur_userid, @RoleId, 0)
			END
			ELSE
			BEGIN
				UPDATE UserRoleXref SET IsDeleted = 0 where UserId = @cur_userid and RoleId = @RoleId
			END
		END
		ELSE IF (@Action = 1) -- Delete permission
		BEGIN
			IF EXISTS (select 1 from UserRoleXref where UserId = @cur_userid and RoleId = @RoleId)
			BEGIN
				UPDATE UserRoleXref SET IsDeleted = 1 where UserId = @cur_userid and RoleId = @RoleId
			END
		END

		Update #users set Processed = 1 where UserId = @cur_userid
	END

	DROP TABLE #users
END



GO
