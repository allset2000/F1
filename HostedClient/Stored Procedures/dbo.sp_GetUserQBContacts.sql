SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/26/2015
-- Description: SP Used to get all QB User's for a given user (all users on all clinics the dictator has access to)
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserQBContacts] (
	@UserId int
) AS 
BEGIN

	SELECT DISTINCT(U.Name), U.QuickBloxUserLogin
	FROM Dictators D
		INNER JOIN Users U on U.UserId = D.UserId
	WHERE D.ClinicId in (SELECT D.ClinicId 
						 FROM Dictators D
							INNER JOIN Clinics C on C.ClinicId = D.ClinicId
						 WHERE D.UserId = @UserId)

END

GO
