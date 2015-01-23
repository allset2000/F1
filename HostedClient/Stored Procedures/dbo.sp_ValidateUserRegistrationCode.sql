SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/20/2015
-- Description: SP Used to validate the Registration Code sent in from mobile
-- =============================================
CREATE PROCEDURE [dbo].[sp_ValidateUserRegistrationCode] (
	@RegCode varchar(20)
) AS 
BEGIN
	DECLARE @ShortCode varchar(10)

	SET @ShortCode = SUBSTRING(@RegCode, 0, CHARINDEX('-',@RegCode,0))

	SELECT UI.PhoneNumber, UI.EmailAddress, UI.ClinicId, UI.FirstName, UI.LastName, C.MobileCode 
	FROM UserInvitations UI
		INNER JOIN Clinics C on C.ClinicId = UI.ClinicId
	WHERE SUBSTRING(SecurityToken, 0, CHARINDEX('-', SecurityToken, 0)) = @RegCode
	and UI.RegisteredUserId is null

END

GO
