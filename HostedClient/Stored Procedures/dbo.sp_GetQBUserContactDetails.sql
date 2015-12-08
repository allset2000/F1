
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Narender Ramadheni
-- Create date: 12/03/2015
-- Description: SP Used to get QB User information 
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetQBUserContactDetails] (
	@QuickBloxUserID int
) AS 
BEGIN

	SELECT U.UserId, U.FirstName, U.MI, U.LastName,  CONCAT(U.FirstName,' ', U.MI,' ', U.LastName) as FullName, 
			U.LoginEmail as Email, U.PhoneNumber, C.ClinicID, C.Name as ClinicName, QBU.QuickBloxUserID, QBU.Login as 'QBUserLogin'
	FROM QuickBloxUsers QBU
		INNER JOIN Users U on U.UserID = QBU.UserID
		INNER JOIN UserClinicXref UCX on UCX.UserId = U.UserID and QBU.QuickBloxUserID = @QuickBloxUserID
		INNER JOIN Clinics C on C.ClinicID = UCX.ClinicID
END
GO
