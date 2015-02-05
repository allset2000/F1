SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Santhosh Mukk
-- Create date: 01/16/2015
-- Description: SP used to check duplicate registration code
-- =============================================
CREATE PROCEDURE [dbo].[sp_CheckInvitationRegCode]
(
	@SecurityToken VARCHAR(20) = ''
)
AS
BEGIN
	SELECT COUNT(*) FROM UserInvitations WHERE SecurityToken = @SecurityToken
END
GO
