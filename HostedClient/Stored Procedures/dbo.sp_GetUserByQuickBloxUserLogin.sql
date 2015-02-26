
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
	Created By: Mikayil Bayramov
	Created Date: 02/242015
	Version: 1.0
	Details: Returns user by QuickBlox user login
	
	Revised Date: Insert revised date here
	Revised By: Insert name of developer this scrip was modified.
	Revision Details: Why this script waschanged?
	Revision Version: What version is this?
*/
CREATE PROCEDURE [dbo].[sp_GetUserByQuickBloxUserLogin] 
(
	@QuickBloxUserLogin VARCHAR(100)
) 
AS 
BEGIN
	SELECT u.UserID, u.UserName, u.ClinicId, u.LoginEmail, u.Name, u.[Password], u.Salt, u.Deleted, u.IsLockedOut, u.LastPasswordReset, u.PasswordAttemptFailure, 
	       u.LastFailedAttempt, u.PWResetRequired, u.SecurityToken, u.LastLoginDate
	FROM [dbo].[Users] AS u INNER JOIN [dbo].[QuickBloxUsers] AS qbu ON u.UserId = qbu.UserID
	WHERE qbu.[Login] = @QuickBloxUserLogin
END
GO
