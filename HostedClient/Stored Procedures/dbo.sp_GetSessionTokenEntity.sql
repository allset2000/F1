SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/19/2015
-- Description: SP called to return a the session entity based on token
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetSessionTokenEntity] (
	@SessionToken varchar(100)
) AS 
BEGIN
		SELECT UserSessionTrackingId, UserId, SessionToken, LastActivity, IsActive, DeviceId 
		FROM UserSessionTracking 
		WHERE SessionToken = @SessionToken
	
END
GO
