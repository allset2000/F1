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
	SELECT UserID, UserName, ClinicId, LoginEmail, Name, [Password], Salt, Deleted, IsLockedOut, LastPasswordReset, PasswordAttemptFailure, 
	       LastFailedAttempt, PWResetRequired, SecurityToken, LastLoginDate, QuickBloxUserLogin, QuickBloxPassword
	FROM [dbo].[Users] 
	WHERE QuickBloxUserLogin = @QuickBloxUserLogin
END
GO
