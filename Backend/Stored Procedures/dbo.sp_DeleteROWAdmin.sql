-- =============================================
-- Author: Santhosh
-- Create date: 03/26/2015
-- Description: SP used to delete row clinic
CREATE PROCEDURE [dbo].[sp_DeleteROWAdmin]
(
	@AdminID VARCHAR(20)
)
AS
BEGIN
	IF EXISTS(SELECT * FROM ROW_AdminsClinics WHERE Admin_ID = @AdminID)
	BEGIN
		SELECT 0
	END
	ELSE
	BEGIN
		DELETE FROM ROW_Admins WHERE Admin_ID = @AdminID
		SELECT 1
	END
END


GO


