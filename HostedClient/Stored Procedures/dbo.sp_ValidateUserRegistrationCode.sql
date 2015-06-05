
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/20/2015
-- Description: SP Used to validate the Registration Code sent in from mobile

-- Modified By: Sam Shoultz
-- Modified On: 6/5/2015
-- Release: D.2
-- Modifications: Added UI.Deleted = 0 on where clause (introduced deleting invitations in this release)
-- =============================================
CREATE PROCEDURE [dbo].[sp_ValidateUserRegistrationCode] (
	@RegCode varchar(20)
) AS 
BEGIN
	DECLARE @ShortCode varchar(10)

	SET @ShortCode = SUBSTRING(@RegCode, 0, CHARINDEX('-',@RegCode,0))

	SELECT UI.PhoneNumber, UI.EmailAddress, UI.ClinicId, UI.FirstName, UI.LastName, C.MobileCode , UI.MI
	FROM UserInvitations UI
		LEFT OUTER JOIN Clinics C on C.ClinicId = UI.ClinicId
	WHERE SUBSTRING(SecurityToken, 0, CHARINDEX('-', SecurityToken, 0)) = @ShortCode
	and UI.RegisteredUserId is null
	and UI.Deleted = 0

END

GO
