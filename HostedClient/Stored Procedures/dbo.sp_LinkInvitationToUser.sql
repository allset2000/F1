
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Santhosh
-- Create date: 08/12/2015
-- Description: SP used to Link Invitation to an existing user
--Modified By: Raghu A
--Modified Date : 08/01/2016
--Description : PendingRegStatus status column value updated
-- =============================================
CREATE PROCEDURE [dbo].[sp_LinkInvitationToUser]
(
	@UserId INT,
	@RegistrationCode VARCHAR(15)
)
AS
BEGIN

     SET NOCOUNT ON;

	IF EXISTS(SELECT '*' FROM UserInvitations WHERE (ISNULL(RegisteredUserId,'') = ''  OR PendingRegStatus=1) AND SecurityToken = @RegistrationCode)
	BEGIN
		UPDATE DBO.UserInvitations
		SET RegisteredUserId = @UserId,
			PendingRegStatus=0
		WHERE SecurityToken = @RegistrationCode

		SELECT 1
	END
	ELSE
	BEGIN
		SELECT 0
	END
END


GO
