SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/14/2015
-- Description: SP called to return a list of all the Session Tokens from the UserSessionTracking table
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetAllSessionTracking] (
	@ClinicId int
) AS 
BEGIN
	IF (@ClinicId < 1)
	BEGIN
		SELECT UserSessionTrackingId, UserId, SessionToken, LastActivity, IsActive FROM UserSessionTracking
	END
	ELSE
	BEGIN
		SELECT UST.UserSessionTrackingId, UST.UserId, UST.SessionToken, UST.LastActivity, UST.IsActive 
		FROM UserSessionTracking UST
			INNER JOIN Users U on U.UserId = UST.UserId
			INNER JOIN Dictators D on D.UserId = U.UserId
		WHERE D.ClinicId = @ClinicId
	END
END
GO
