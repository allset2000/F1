
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stored Procedure

-- =============================================
-- Author: Sam Shoultz
-- Create date: 05/04/2015
-- Description: SP used to validate and return a user invitation if one already exists

-- Modified by: Mikayil Bayramov	
-- Modified Date: 9/28/2015
-- Modification Code: 001
-- Modification Details: Implemented new improvced logic to validate new invitations
-- =============================================
CREATE PROCEDURE [dbo].[sp_ValidateNewInvitation]
(
	@InvitationMethod INT,
	@PhoneNumber varchar(100),
	@EmailAddress varchar(100)
)
AS
BEGIN
	SELECT TOP 1 UserInvitationId, FirstName, MI, LastName, EmailAddress, PhoneNumber, InvitationSent, RequestingUserId, ClinicId,
		         InvitationMethod, RoleId, SecurityToken, DateTimeRequested, DateTimeInvitationSent, IsDemoUSer, RegisteredUserId, InvitationMessage
	FROM UserInvitations
	WHERE RegisteredUserId IS NULL AND 
	     PhoneNumber = COALESCE(@PhoneNumber, PhoneNumber) AND
		 EmailAddress = COALESCE(@EmailAddress, EmailAddress)

	/*
	Diabled in favour of new improved implementation. See Modification code: 001
	IF EXISTS (SELECT 1 FROM UserInvitations WHERE RegisteredUserId is null and (PhoneNumber = @PhoneNumber or EmailAddress = @EmailAddress)) BEGIN
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
		WHERE RegisteredUserId is null and (PhoneNumber = @PhoneNumber or EmailAddress = @EmailAddress)
	END
	*/
END


GO
