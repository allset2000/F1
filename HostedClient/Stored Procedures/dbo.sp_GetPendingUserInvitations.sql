SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/23/2015
-- Description: SP used to pull the list of pending invitations for a given user
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPendingUserInvitations]
	@UserId INT
AS 
BEGIN

	SELECT UserInvitationId, FirstName, MI, LastName, EmailAddress, PhoneNumber, ClinicId, SecurityToken, DateTimeRequested, DateTimeInvitationSent 
	FROM UserInvitations 
	WHERE RequestingUserId = @UserId and RegisteredUserId is null

END
GO
