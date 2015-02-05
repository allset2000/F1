SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Santhosh Mukk
-- Create date: 01/16/2015
-- Description: SP used to Update Invitation when Email or SMS sent
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateInvitation]
(
	@SecurityToken VARCHAR(20) = ''
)
AS
BEGIN
	UPDATE [UserInvitations]
	SET [InvitationSent] = 1
	, [DateTimeInvitationSent] = GETDATE()
	WHERE [SecurityToken] = @SecurityToken
END
GO
