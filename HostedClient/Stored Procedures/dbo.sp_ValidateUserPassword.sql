
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 01/30/2015
-- Description: SP used to validate a users password and application access based on the roles
-- =============================================
CREATE PROCEDURE [dbo].[sp_ValidateUserPassword]
(
	@UserId INT,
	@Password varchar(100),
	@ApplicationId INT
)
AS
BEGIN

	DECLARE @False bit
	DECLARE @True bit
	DECLARE @InvalidPassword int
	DECLARE @AppAccessInvalid int

	SET @False = 0
	SET @True = 1
	SET @InvalidPassword = 1
	SET @AppAccessInvalid = 2


	-- Compare password sent vs db password
	IF EXISTS (select * from Users where UserId = @UserId and Password = @Password)
	BEGIN
		-- Compare user roles for application access
		IF EXISTS (select * from UserRoleXref URX INNER JOIN RoleApplicationXref RAX on RAX.RoleId = URX.RoleId WHERE URX.UserId = @UserId and RAX.ApplicationId = @ApplicationId)
		BEGIN
			UPDATE Users SET LastLoginDate = GETDATE() WHERE UserId = @UserId
			SELECT @True,0
		END
		ELSE
		BEGIN
			SELECT @False,@AppAccessInvalid
		END
	END
	ELSE
	BEGIN
		SELECT @False,@InvalidPassword
	END
END


GO
