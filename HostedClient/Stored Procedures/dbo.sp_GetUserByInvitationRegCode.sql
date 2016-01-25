SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserByInvitationRegCode]
	-- Add the parameters for the stored procedure here
	@RegistrationCode VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT UserID, U.ClinicID, U.LoginEmail, U.Name, U.Password, U.Salt, U.UserName, U.Deleted
		   ,U.IsLockedOut, U.LastPasswordReset, U.PasswordAttemptFailure, U.LastFailedAttempt, U.PWResetRequired
			,U.SecurityToken, U.LastLoginDate, U.FirstName, U.MI, U.LastName, U.PhoneNumber, U.TimeZoneId, U.FirstTimeLogin
			,U.IsUserValidated, U.DowntimeAlertIDToHide, U.PhoneExtension
	FROM dbo.Users U
	INNER JOIN dbo.UserInvitations UI ON UI.RegisteredUserId=U.UserID
	WHERE UI.SecurityToken=@RegistrationCode




END
GO
