SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 2/19/2015
-- Description: SP Used to get clinics the user has access to - this is used for mobile dictate / pulling clinical data
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserClinics] (
	@UserId int
) AS 
BEGIN

	SELECT ClinicID from Dictators Where UserId = @UserId

END

GO
