
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

	-- Compare password sent vs db password
	IF EXISTS (select * from Users where UserID = @UserId and Password = @Password and Deleted = 0)
	BEGIN
		-- Compare user roles for application access
		IF EXISTS (select * from UserRoleXref URX INNER JOIN RoleApplicationXref RAX on RAX.RoleId = URX.RoleId WHERE URX.UserId = @UserId and RAX.ApplicationId = @ApplicationId and URX.IsDeleted = 0 and RAX.IsDeleted = 0)
		BEGIN
			UPDATE Users SET LastLoginDate = GETDATE() WHERE UserID = @UserId
			SELECT @True as 'Auth', @True as 'AppAccess'
		END
		ELSE
		BEGIN
			SELECT @True as 'Auth', @False as 'AppAccess'  -- User access validated (correct password) but application access denied
		END
	END
	ELSE
	BEGIN
		SELECT @False as 'Auth', @False as 'AppAccess'  -- User access invalid, wrong password / application acess denied
	END
END


GO
