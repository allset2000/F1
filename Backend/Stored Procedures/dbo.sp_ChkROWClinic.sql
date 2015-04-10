-- =============================================
-- Author: Santhosh
-- Create date: 03/26/2015
-- Description: SP used to check duplicate row clinic
CREATE PROCEDURE [dbo].[sp_ChkROWClinic]
(
	@RowClinicID INT
	, @PermissionID INT
)
AS
BEGIN
	SELECT COUNT(*) FROM ROW_AdminsClinics WHERE Clinic_ID = @RowClinicID AND PermissionId != @PermissionID
END


GO


