/****** Object:  StoredProcedure [dbo].[sp_LinkInvitationToUser]    Script Date: 8/17/2015 11:29:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Santhosh
-- Create date: 08/12/2015
-- Description: SP used to Link Invitation to an existing user
-- =============================================
CREATE PROCEDURE [dbo].[sp_LinkInvitationToUser]
(
	@UserId INT
	, @RegistrationCode VARCHAR(15)
)
AS
BEGIN
	UPDATE UserInvitations
	SET RegisteredUserId = @UserId
	WHERE SecurityToken = @RegistrationCode
END


GO


