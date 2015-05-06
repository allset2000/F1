SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 05/04/2015
-- Description: SP used to validate and return a user invitation if one already exists
-- =============================================
CREATE PROCEDURE [dbo].[sp_ValidateNewInvitation]
(
	@InvitationMethod INT,
	@PhoneNumber varchar(100),
	@EmailAddress varchar(100)
)
AS
BEGIN

	IF EXISTS (SELECT 1 FROM UserInvitations WHERE PhoneNumber = @PhoneNumber or EmailAddress = @EmailAddress)
	BEGIN
		SELECT TOP 1 UserInvitationId,
					 FirstName,
					 MI,
					 LastName,
					 EmailAddress,
					 PhoneNumber,
					 InvitationSent,
					 RequestingUserId,
					 ClinicId,
					 InvitationMethod,
					 RoleId,
					 SecurityToken,
					 DateTimeRequested,
					 DateTimeInvitationSent,
					 IsDemoUSer,
					 RegisteredUserId,
					 InvitationMessage
		FROM UserInvitations
		WHERE PhoneNumber = @PhoneNumber or EmailAddress = @EmailAddress
	END

END
GO
