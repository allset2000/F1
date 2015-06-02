
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

	CREATE TABLE #contactlist
	(
		UserId int,
		FirstName varchar(100),
		MI varchar(50),
		LastName varchar(100),
		QuickBloxUserID int,
		QBUserLogin varchar(100),
		IsFavorite bit
	)

	-- Step1: Add the User to the list (mobile needs the user added at all times)
	INSERT INTO #contactlist (UserId,FirstName,MI,LastName,QuickBloxUSerID,QBUserLogin,IsFavorite)
	SELECT DISTINCT(U.UserId), U.FirstName, U.MI, U.LastName, QBU.QuickBloxUserID, QBU.Login as 'QBUserLogin', 0 as 'IsFavorite'
	FROM Users U
		INNER JOIN QuickBloxUsers QBU on U.UserID = QBU.UserID
	WHERE U.UserId = @UserId

	-- Step 1a: For the users with dictators associated (doctors) mapped to the same clinics of the users clincs
	INSERT INTO #contactlist (UserId,FirstName,MI,LastName,QuickBloxUSerID,QBUserLogin,IsFavorite)
	SELECT DISTINCT(U.UserId), U.FirstName, U.MI, U.LastName, QBU.QuickBloxUserID, QBU.Login as 'QBUserLogin', 0 as 'IsFavorite'
	FROM Dictators D
		INNER JOIN Users U on U.UserId = D.UserId
		INNER JOIN QuickBloxUsers QBU on U.UserID = QBU.UserID
	WHERE D.ClinicId in (SELECT D.ClinicId 
						 FROM Dictators D
							INNER JOIN Clinics C on C.ClinicId = D.ClinicId
						 WHERE D.UserId = @UserId)
	and U.UserId not in (select UserId from #contactlist)

	-- Step 2: For the Users who are SM only (no dictators) mapped to the same clinics for the user clinics
	INSERT INTO #contactlist (UserId,FirstName,MI,LastName,QuickBloxUSerID,QBUserLogin,IsFavorite)
	SELECT U.UserId, U.FirstName, U.MI, U.LastName, QBU.QuickBloxUserID, QBU.Login as 'QBUserLogin', 0 as 'IsFavorite'
	FROM Users U
		INNER JOIN QuickBloxUsers QBU on U.UserID = QBU.UserID
	WHERE U.ClinicId in (SELECT D.ClinicId 
						 FROM Dictators D
							INNER JOIN Clinics C on C.ClinicId = D.ClinicId
						 WHERE D.UserId = @UserId)
	and U.UserId not in (select UserId from #contactlist)

	-- Step3: Add Users who the user has invited and they are registered
	INSERT INTO #contactlist (UserId,FirstName,MI,LastName,QuickBloxUSerID,QBUserLogin,IsFavorite)
	SELECT	U.UserId, U.FirstName, U.MI, U.LastName, QBU.QuickBloxUserID, QBU.Login as 'QBUserLogin', 0 as 'IsFavorite'
	FROM UserInvitations UI
		INNER JOIN Users U on UI.RegisteredUserId = U.UserId
		INNER JOIN QuickBloxUsers QBU on U.UserID = QBU.UserID
	WHERE UI.RequestingUserId = @UserId
	and UI.RegisteredUserId not in (select UserId from #contactlist)

	-- Step4: Add pending invitations to the list
	INSERT INTO #contactlist (UserId,FirstName,MI,LastName,QuickBloxUSerID,QBUserLogin,IsFavorite)
	SELECT	null, UI.FirstNAme, UI.MI, UI.LastName, null, null, 0 as 'IsFavorite'
	FROM UserInvitations UI
	WHERE UI.RequestingUserId = @UserId
	and UI.RegisteredUserId is null and UI.FirstName is not null and UI.InvitationSent = 1

	-- Step5: Add User that invited you
	INSERT INTO #contactlist (UserId,FirstName,MI,LastName,QuickBloxUSerID,QBUserLogin,IsFavorite)
	SELECT	U.UserId, U.FirstNAme, U.MI, U.LastName, QBU.QuickBloxUserID, QBU.Login as 'QBUserLogin', 0 as 'IsFavorite'
	FROM UserInvitations UI
		INNER JOIN Users U on U.UserId = UI.RequestingUserId
		INNER JOIN QuickBloxUsers QBU on U.UserID = QBU.UserID
	WHERE UI.RegisteredUserId = @UserId and U.UserId not in (select UserId from #contactlist)

	DECLARE @ClinicId INT
	SET @ClinicId = (SELECT ClinicId FROM Users WHERE UserId = @UserId)

	IF (@ClinicId != (SELECT ConfigValue from SystemConfiguration where ConfigKey = 'SMDefaultClinic'))
	BEGIN
		-- Step6a: Add any user that belongs to the same clinic as you but is not the default SM clinic and is a dictator
		INSERT INTO #contactlist (UserId,FirstName,MI,LastName,QuickBloxUSerID,QBUserLogin,IsFavorite)
		SELECT DISTINCT U.UserId, U.FirstNAme, U.MI, U.LastName, QBU.QuickBloxUserID, QBU.Login as 'QBUserLogin', 0 as 'IsFavorite'
		FROM Dictators D
			INNER JOIN Users U on U.UserId = D.UserId
			INNER JOIN QuickBloxUsers QBU on U.UserID = QBU.UserID
		WHERE D.ClinicId = @ClinicId and U.UserId not in (select UserId from #contactlist)

		-- Step6b: Add any user that belongs to the same clinic as you but is not the default SM clinic and is a SM only user
		INSERT INTO #contactlist (UserId,FirstName,MI,LastName,QuickBloxUSerID,QBUserLogin,IsFavorite)
		SELECT	U.UserId, U.FirstNAme, U.MI, U.LastName, QBU.QuickBloxUserID, QBU.Login as 'QBUserLogin', 0 as 'IsFavorite'
		FROM Users U
			INNER JOIN QuickBloxUsers QBU on U.UserID = QBU.UserID
		WHERE U.UserId = @UserId and U.UserId not in (select UserId from #contactlist)
	END

	-- Step7: Map favorites
	UPDATE #contactlist set IsFavorite = 1 WHERE UserId in (SELECT FavUserId FROM SMContactFavorites WHERE UserId = @UserId and IsDeleted = 0)

	SELECT * FROM #contactlist

	DROP TABLE #contactlist

END
GO
