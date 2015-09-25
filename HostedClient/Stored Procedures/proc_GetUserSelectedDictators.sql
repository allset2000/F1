
/****** Object:  StoredProcedure [dbo].[proc_GetUserSelectedDictators]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author: TAMOJIT CHAKRABORTY
-- Create date: 9/24/2015
-- Description: SP Used to return a list of all selected dictators a user is mapped to
-- =============================================
CREATE PROCEDURE [dbo].[proc_GetUserSelectedDictators] (
	@userid int,
	@clinicid int
) AS 
BEGIN

		SELECT D.*,concat(C.cliniccode,D.DictatorName) as BackendDictatorID , C.Name + ' (' + CAST(C.ClinicId as varchar(10)) + ')' as 'ClinicName',C.ClinicId FROM PortalUserDictatorXref PUD
			INNER JOIN Dictators D on D.DictatorId = PUD.DictatorId
			INNER JOIN Clinics C on C.ClinicID=D.ClinicID
		WHERE PUD.UserId = @userid and PUD.IsDeleted = 0 and D.Deleted = 0
		and C.ClinicID=@clinicid
		

END


