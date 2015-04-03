
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/14/2015
-- Description: SP used to pull the User Entity (object) from the DB

-- Modified By: Mikayil Bayramov
-- Modified Date: 02/17/2017
-- Modifications: Added QuickBloxUserLogin and QuickBloxPassword fields.
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserByUserName] (
	@UserName varchar(100)
) AS 
BEGIN
	SELECT UserID, UserName, ClinicId, LoginEmail, Name, Password, Salt, Deleted, IsLockedOut,LastPasswordReset,PasswordAttemptFailure,LastFailedAttempt,PWResetRequired,SecurityToken,LastLoginDate,Firstname,Lastname
	FROM Users where UserName = @UserName
END
GO
