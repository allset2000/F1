-- =============================================
-- Author: Santhosh
-- Create date: 03/26/2015
-- Description: SP used to get all Row User Details
CREATE PROCEDURE [dbo].[getROWAdminByID]
(
	@Admin_ID VARCHAR(50)
)
AS
BEGIN
	SELECT 
		Admin_ID
		, Admin_Password
	FROM ROW_Admins
	WHERE Admin_ID = @Admin_ID
END



GO


