SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Vivek
-- Create date: 9/30/2015
-- Description: SP used to pull the User Passwords from the DB

--Created by:Entrada dev
--Creation Date:06/12/2015
-- =============================================
CREATE PROCEDURE [dbo].[proc_GetPasswordHistory] (
	@UserId int
) AS 
BEGIN
	DECLARE @PreviousPasswordCount int
	--get PreviousPasswordCount from clinics table
	SELECT @PreviousPasswordCount = PreviousPasswordCount from clinics 
	WHERE ClinicID = (SELECT top 1 clinicID from UserClinicXref WHERE UserId = @UserId) 

SELECT top (@PreviousPasswordCount) PasswordHistoryId, UserId, Password, Salt,
	IsActive, DateCreated
FROM UserPasswordHistory
WHERE (UserId = @UserId) AND (IsActive = 1)
ORDER BY DateCreated desc

END
GO
