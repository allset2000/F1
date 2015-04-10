-- =============================================
-- Author: Santhosh
-- Create date: 03/26/2015
-- Description: SP used to delete row clinic
CREATE PROCEDURE [dbo].[sp_DeleteROWAdminClinic]
(
	@PermissionID INT
)
AS
BEGIN
	DELETE FROM ROW_AdminsClinics WHERE PermissionId = @PermissionID
	SELECT 1
END


GO


