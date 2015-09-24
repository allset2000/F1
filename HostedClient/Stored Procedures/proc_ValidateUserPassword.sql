USE [EntradaHostedClient]
GO
/****** Object:  StoredProcedure [dbo].[proc_ValidateUserPassword]    Script Date: 8/17/2015 11:24:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Entrada_Dev
-- Create date: 06/21/2015
-- Description: SP used to validate a users password and application access based on the roles
-- =============================================
CREATE PROCEDURE [dbo].[proc_ValidateUserPassword]
(
	@UserId INT,
	@Password varchar(300),
	@ApplicationId INT
)
AS
BEGIN

DECLARE @IsAuthenticated bit = 0
	 DECLARE @IsAppAccessAllowed bit = 0

	 BEGIN TRANSACTION
	 IF EXISTS (SELECT 1 FROM Users WHERE UserID = @UserId and Password = @Password and Deleted=0)
		BEGIN
			SET @IsAuthenticated = 1
			UPDATE Users SET LastLoginDate = GETDATE(), IsLockedOut=0, PasswordAttemptFailure=0, PWResetRequired=0 WHERE UserID = @UserId

			IF EXISTS(SELECT 1 from UserRoleXref URX 
				INNER JOIN RoleApplicationXref RAX on RAX.RoleId = URX.RoleId 
				WHERE URX.UserId = @UserId and RAX.ApplicationId = @ApplicationId and URX.IsDeleted = 0 and RAX.IsDeleted = 0)
				BEGIN
				SET @IsAppAccessAllowed=1
				END
			SELECT @IsAuthenticated as AUTH, @IsAppAccessAllowed as APPACCESS, * FROM USERS WHERE UserID = @UserId
		END
	 COMMIT TRANSACTION
	END