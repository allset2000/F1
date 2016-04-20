
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/20/2015
-- Description: SP Used to validate the Registration Code sent in from mobile

-- Modified By: Sam Shoultz, Raghu A
-- Modified On: 6/5/2015, 08/01/2016
-- Release: D.2
-- Modifications: Added UI.Deleted = 0 on where clause (introduced deleting invitations in this release),
-- Get Records based on new invitation pending status
-- =============================================
CREATE PROCEDURE [dbo].[sp_ValidateUserRegistrationCode] (
	@RegCode VARCHAR(20)
) AS 
BEGIN

    SET NOCOUNT ON;
	
	SELECT UI.PhoneNumber, UI.EmailAddress, UI.ClinicId, UI.FirstName, UI.LastName, C.MobileCode , UI.MI
	FROM DBO.UserInvitations UI
		LEFT OUTER JOIN DBO.Clinics C ON C.ClinicId = UI.ClinicId
	WHERE  SecurityToken = @RegCode
		AND (UI.RegisteredUserId IS NULL OR PendingRegStatus=1)
		AND UI.Deleted = 0

END

GO
