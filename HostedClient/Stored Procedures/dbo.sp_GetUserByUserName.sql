SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/14/2015
-- Description: SP used to pull the User Entity (object) from the DB
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserByUserName] (
	@UserName varchar(100)
) AS 
BEGIN
	SELECT UserId, UserName, ClinicId, LoginEmail, Name, Password, Salt, Deleted, IsLockedOut,LastPasswordReset,PasswordAttemptFailure,LastFailedAttempt,DoResetPassword,SecurityToken,LastLoginDate
	FROM Users where UserName = @UserName
END
GO
