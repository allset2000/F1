-- =============================================
-- Author: Santhosh
-- Create date: 03/26/2015
-- Description: SP used to update ROW Admin Clinic
CREATE PROCEDURE [dbo].[sp_UpdateROWAdminClinic] 
	@PermissionID INT,
	@AdminID varchar(20),
	@ClinicID INT
AS
BEGIN	
	UPDATE ROW_AdminsClinics
	SET	Admin_ID = @AdminID, 
		Clinic_ID = @ClinicID
	WHERE PermissionId = @PermissionID
END


GO


