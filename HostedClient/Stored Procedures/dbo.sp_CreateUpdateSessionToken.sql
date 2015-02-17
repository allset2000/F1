SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/15/2015
-- Description: SP used to insert a new / update an old record into the UserSessionTracking table by mobile
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateUpdateSessionToken] (
	 @UserId int,
	 @SessionToken uniqueidentifier,
	 @LastActivity datetime,
	 @IsActive bit
) AS 
BEGIN

	IF EXISTS (select * from UserSessionTracking where UserId = @UserId)
	BEGIN
		UPDATE UserSessionTracking SET SessionToken = @SessionToken, LastActivity = @LastActivity, IsActive = @IsActive WHERE UserId = @UserId
	END
	ELSE
	BEGIN
		INSERT INTO UserSessionTracking(UserId, SessionToken, LastActivity, IsActive) values(@UserId, @SessionToken, @LastActivity, 1)
	END

	SELECT * FROM UserSessionTracking WHERE UserId = @UserId

END


GO
