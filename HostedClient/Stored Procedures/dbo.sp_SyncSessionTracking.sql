SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 11/14/2015
-- Description: SP used to sync the UserSessionTracking table with the SessionCollection in the DictateAPI WS memory
-- =============================================
CREATE PROCEDURE [dbo].[sp_SyncSessionTracking] (
	@UserId int,
	@Token uniqueidentifier,
	@LastActive DateTime
	--@Values SessionTracking READONLY
) AS 
BEGIN
	IF EXISTS (select * from UserSessionTracking where UserId = @UserId)
	BEGIN
		UPDATE UserSessionTRacking SET SessionToken = @Token, LastActivity = @LastActive WHERE UserId = @UserId
	END
	ELSE
	BEGIN
		INSERT INTO UserSessionTracking(UserId,SessionToken,LastActivity,IsActive) VALUES(@UserId, @Token, @LastActive, 1)
	END
END
GO
