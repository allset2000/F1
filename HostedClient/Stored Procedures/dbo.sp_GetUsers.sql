
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/2/2015
-- Description: SP Used to get users from the user table
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUsers] (
	@clinicid int
) AS 
BEGIN

	IF (@clinicid <= 0)
	BEGIN
		SELECT UserID,
			   ClinicId,
			   LoginEmail,
			   Name,
			   Password,
			   Salt,
			   UserName,
			   Deleted,
			   IsLockedOut,
			   LastPasswordReset,
			   PasswordAttemptFailure,
			   LastFailedAttempt,
			   PWResetRequired,
			   SecurityToken,
			   LastLoginDate,
			   FirstName,
			   MI,
			   LastName,
			   PhoneNumber,
			   TimeZoneId, 
			   CASE WHEN Deleted = 1 THEN 'Deleted' WHEN IsLockedOut = 1 THEN 'Portal Max Login Failure' ELSE 'Enabled' END as 'UserStatus' 
		FROM Users
	END
	ELSE
	BEGIN
		SELECT UserID,
			   ClinicId,
			   LoginEmail,
			   Name,
			   Password,
			   Salt,
			   UserName,
			   Deleted,
			   IsLockedOut,
			   LastPasswordReset,
			   PasswordAttemptFailure,
			   LastFailedAttempt,
			   PWResetRequired,
			   SecurityToken,
			   LastLoginDate,
			   FirstName,
			   MI,
			   LastName,
			   PhoneNumber,
			   TimeZoneId, 
			   CASE WHEN Deleted = 1 THEN 'Deleted' WHEN IsLockedOut = 1 THEN 'Portal Max Login Failure' ELSE 'Enabled' END as 'UserStatus' 
		FROM Users
		WHERE ClinicId = @clinicid
	END

END

GO
