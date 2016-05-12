SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 6/9/2015
-- Description: SP Used to return a list of all clinics a user has access to
-- added DISTINCT on 12-May-2016 by baswaraj 
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserClinicXref] (
	@userid int
) AS 
BEGIN

		SELECT DISTINCT C.* FROM UserClinicXref UCX
			INNER JOIN Clinics C on C.ClinicId = UCX.ClinicId
		WHERE UCX.UserId = @userid and UCX.IsDeleted = 0

END

GO
