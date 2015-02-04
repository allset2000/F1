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
	
	SET @False = 0
	SET @True = 1

	IF EXISTS (select * from Users where UserId = @UserId and Password = @Password)
	BEGIN
		IF EXISTS (select * from UserRoleXref URX INNER JOIN RoleApplicationXref RAX on RAX.RoleId = URX.RoleId WHERE URX.UserId = @UserId and RAX.ApplicationId = @ApplicationId)
		BEGIN
			SELECT @True,0
		END
		ELSE
		BEGIN
			SELECT @False,2
		END
	END
	ELSE
	BEGIN
		SELECT @False,1
	END
END


GO
