-- =============================================
-- Author: Santhosh
-- Create date: 03/26/2015
-- Description: SP used to update ROW Admin
CREATE PROCEDURE [dbo].[sp_UpdateROWAdmin] 
	@AdminID VARCHAR(20),
	@Username varchar(20),
	@Password varchar(100)
AS
BEGIN	
	UPDATE ROW_Admins
	SET	Admin_ID = @Username, 
		Admin_Password = @Password
	WHERE Admin_ID = @AdminID
END

GO


