SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 6/9/2015
-- Description: SP Used to return a list of all dictators a user has access to (for every clinic they have access to)
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserClinicDictators] (
	@userid int
) AS 
BEGIN

		SELECT C.Name + ' (' + CAST(C.ClinicId as varchar(10)) + ')' as 'ClinicName',concat(C.cliniccode,D.DictatorName) as BackendDictatorID, D.* FROM UserClinicXref UCX
			INNER JOIN Clinics C on C.ClinicId = UCX.ClinicId
			INNER JOIN Dictators D on D.ClinicId = C.ClinicId
		WHERE UCX.UserId = @userid and UCX.IsDeleted = 0 and C.Deleted = 0

END

GO
