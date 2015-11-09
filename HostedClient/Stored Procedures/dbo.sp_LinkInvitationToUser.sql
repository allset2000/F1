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
	IF EXISTS(SELECT * FROM UserInvitations WHERE ISNULL(RegisteredUserId,-1) = -1 AND SecurityToken = @RegistrationCode)
	BEGIN
	UPDATE UserInvitations
	SET RegisteredUserId = @UserId
	WHERE SecurityToken = @RegistrationCode

		SELECT 1
	END
	ELSE
	BEGIN
		SELECT 0
	END
END



GO


