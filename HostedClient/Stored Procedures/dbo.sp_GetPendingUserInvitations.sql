
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/23/2015
-- Description: SP used to pull the list of pending invitations for a given user
--Modified By: Raghu A
--Modified Date : 08/01/2016
--Description : PendingRegStatus  column value updated
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPendingUserInvitations]
	@UserId INT
AS 
BEGIN

   SET NOCOUNT ON;

	SELECT UserInvitationId, FirstName, MI, LastName, EmailAddress, PhoneNumber, ClinicId, SecurityToken, DateTimeRequested, DateTimeInvitationSent 
	FROM DBO.UserInvitations 
	WHERE RequestingUserId = @UserId
		 and (RegisteredUserId is null OR PendingRegStatus=1) 
		 and Deleted = 0

END
GO
