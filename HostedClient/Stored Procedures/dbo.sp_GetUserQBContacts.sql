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
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserQBContacts] (
	@UserId int
) AS 
BEGIN

	DECLARE @DefaultClinicID int
	SELECT @DefaultClinicID = ConfigValue from SystemConfiguration where ConfigKey = 'SMDefaultClinic'

	SELECT U.UserId, U.FirstName, U.MI, U.LastName,  CONCAT(U.FirstName,' ', U.MI,' ', U.LastName) as FullName, U.LoginEmail as Email, U.PhoneNumber, C.ClinicID, C.Name as ClinicName, QBU.QuickBloxUserID, 
		QBU.Login as 'QBUserLogin', 
		CASE
			WHEN F.FavUserId IS NULL THEN 0
			ELSE 1
		END as 'IsFavorite'
	FROM Users U
		INNER JOIN QuickBloxUsers QBU on U.UserID = QBU.UserID
		INNER JOIN UserClinicXref UCX on UCX.UserId = U.UserID
		INNER JOIN Clinics C on C.ClinicID = UCX.ClinicID
		LEFT JOIN SMContactFavorites F on U.UserID = F.FavUserId
	WHERE
		(F.UserID IS NULL OR (F.UserID = @UserId AND F.IsDeleted=0)) AND 
		 (
		--All users who belong to the clinics I belong to
		--Don't include the users from SMDefaultClinic even if I belong there...
		U.UserId in (SELECT UserId FROM UserClinicXref WHERE ClinicId in 
		(SELECT UCX.ClinicId FROM Users U INNER JOIN UserClinicXref UCX on U.UserID = UCX.UserID 
		 WHERE U.UserID = @UserId and UCX.IsDeleted=0 AND UCX.ClinicId <> @DefaultClinicID))
		--Users who're invited by me and registered
		OR U.UserId in (SELECT RegisteredUserId FROM UserInvitations UI WHERE RequestingUserId = @UserId)
		--User who invited me
		OR U.UserId in (SELECT RequestingUserId FROM UserInvitations UI WHERE RegisteredUserId = @UserId)
		)
		--I must be added...
		OR U.UserId = @UserId
	UNION ALL

	-- Users who're invited by me but not registered yet...
	SELECT null, UI.FirstName, UI.MI, UI.LastName, CONCAT(UI.FirstName,' ', UI.MI,' ', UI.LastName) as FullName, UI.EmailAddress as Email, UI.PhoneNumber, null, null, null, null, 0 as 'IsFavorite'
	FROM UserInvitations UI
	WHERE UI.RequestingUserId = @UserId
	and UI.RegisteredUserId is null and UI.FirstName is not null and UI.InvitationSent = 1


END
GO
