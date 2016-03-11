
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/26/2015
-- Description: SP Used to get all QB User's for a given user (all users on all clinics the dictator has access to)
-- Modified by Vivek on 9/29/2015 - changed the logic to refer UserClinicXref instead of User.ClinicID
-- Modified by Narender on 12/03/2015 - Added FullName,Email,PhoneNo,ClinicID and ClinicName to select statement
-- Modified by Santhosh on 02/19/2016 - Pulling only active users
-- Modified by Vivek on 03/08/2016 - no WHERE clause for SMContactFavorites. Proper handling of PendingRegStatus.
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserQBContacts] (
	@UserId int
) AS 
BEGIN

	DECLARE @DefaultClinicID int
	SELECT @DefaultClinicID = ConfigValue from SystemConfiguration where ConfigKey = 'SMDefaultClinic'

	SELECT U.UserId, U.FirstName, U.MI, U.LastName,  
		CONCAT(LTRIM(RTRIM(U.FirstName)), CASE WHEN LTRIM(RTRIM(U.MI)) <> '' THEN ' ' + LTRIM(RTRIM(U.MI)) + ' ' ELSE ' ' END, LTRIM(RTRIM(U.LastName))) as FullName, 
		U.LoginEmail as Email, U.PhoneNumber, C.ClinicID, C.Name as ClinicName, QBU.QuickBloxUserID, 
		QBU.Login as 'QBUserLogin', 
		CASE
			WHEN F.UserID=@UserID and F.IsDeleted=0 THEN 1
			ELSE 0
		END as 'IsFavorite'
	FROM Users U
		INNER JOIN QuickBloxUsers QBU on U.UserID = QBU.UserID
		INNER JOIN UserClinicXref UCX on UCX.UserId = U.UserID
		INNER JOIN Clinics C on C.ClinicID = UCX.ClinicID
		LEFT JOIN SMContactFavorites F on U.UserID = F.FavUserId
	WHERE
	    --Only Active users
		U.Deleted = 0 AND
		 (
		--All users who belong to the clinics I belong to
		--Don't include the users from SMDefaultClinic even if I belong there...
		U.UserId in (SELECT UserId FROM UserClinicXref UCX1 WHERE UCX1.IsDeleted=0 and UCX1.ClinicId in 
		(SELECT UCX2.ClinicId FROM Users U INNER JOIN UserClinicXref UCX2 on U.UserID = UCX2.UserID 
		 WHERE U.UserID = @UserId and UCX2.IsDeleted=0 AND UCX2.ClinicId <> @DefaultClinicID))
		--Users who're invited by me and registered
		OR U.UserId in (SELECT RegisteredUserId FROM UserInvitations UI WHERE RequestingUserId = @UserId and RegisteredUserId is not null)
		--User who invited me
		OR U.UserId in (SELECT RequestingUserId FROM UserInvitations UI WHERE RegisteredUserId = @UserId)
		)
		--I must be added...
		OR U.UserId = @UserId
	UNION ALL
	-- Users who're invited by me but not registered yet...	  
		SELECT NULL, UI.FirstName, UI.MI, UI.LastName, CONCAT(UI.FirstName,' ', UI.MI,' ', UI.LastName) as FullName, UI.EmailAddress as Email, UI.PhoneNumber, null, null, null, null, 0 as 'IsFavorite'
		FROM UserInvitations UI
		WHERE UI.RequestingUserId = @UserId
		AND (UI.RegisteredUserId is NULL)  and UI.FirstName is not null and UI.InvitationSent = 1


END


GO
