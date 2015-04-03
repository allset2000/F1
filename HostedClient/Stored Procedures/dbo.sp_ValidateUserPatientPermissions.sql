SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 03/30/2015
-- Description: SP used to validate if the user passed in has been granted permission to the patient info sharing
-- =============================================
CREATE PROCEDURE [dbo].[sp_ValidateUserPatientPermissions]
(
	@PatientId INT,
	@UserID INT
)
AS
BEGIN

	select count(*) from PatientDataAccess PDA
		inner join MessageThreads MT on MT.MessageThreadID = PDA.MessageThreadId
		inner join PatientDataAccessPermissions PDAP on PDAP.PatientDataAccessPermissionId = PDA.PatientDataAccessPermissionId
	where PDA.userid = @UserID and MT.PatientID = @PatientId and PDAP.PermissionCode in (1,2)

END


GO
