SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/2/2015
-- Description: SP Used to get users from the user table
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUsers] (
	@clinicid int
) AS 
BEGIN

	IF (@clinicid <= 0)
	BEGIN
		SELECT * FROM Users
	END
	ELSE
	BEGIN
		SELECT * FROM Users WHERE ClinicId = @clinicid
	END

END

GO
