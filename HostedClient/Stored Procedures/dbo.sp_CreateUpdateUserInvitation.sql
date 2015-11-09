SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 6/3/2015
-- Description: SP used to Create / Update User Invitation's
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateUpdateUserInvitation] (
	@UserInvitationId INT,
    @FirstName VARCHAR(100),
	@MI VARCHAR(100),
    @LastName VARCHAR(100),
	@EmailAddress VARCHAR(100), 
	@PhoneNumber VARCHAR(15), 
	@InvitationSent BIT, 
	@RequestingUserID INT, 
	@ClinicId INT, 
	@InvitationMethod INT, 
	@RoleId VARCHAR(500), 
	@SecurityToken VARCHAR(50), 
	@RegisteredUserId INT, 
	@InvitationMessage VARCHAR(1500), 
	@IntivationTypeId INT, 
	@Deleted BIT
) AS 
BEGIN
	UPDATE UserInvitations SET FirstName = @FirstName,
							   MI = @MI,
							   LastName = @LastName,
							   EmailAddress = @EmailAddress,
							   PhoneNumber = @PhoneNumber,
							   InvitationSent = @InvitationSent,
							   RequestingUserId = @RequestingUserID,
							   ClinicId = @ClinicId,
							   InvitationMethod = @InvitationMethod,
							   RoleId = @RoleId,
							   SecurityToken = @SecurityToken,
							   RegisteredUserId = @RegisteredUserId,
							   InvitationMessage = @InvitationMessage,
							   InvitationTypeId = @IntivationTypeId,
							   Deleted = @Deleted
	WHERE UserInvitationId = @UserInvitationId

	SELECT * FROM UserInvitations WHERE UserInvitationId = @UserInvitationId
END



GO
