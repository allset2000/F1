-- =============================================
-- Author: Santhosh
-- Create date: 03/26/2015
-- Description: SP used to check duplicate row user name
CREATE PROCEDURE [dbo].[sp_ChkROWUserName]
(
	@Username varchar(20)
)
AS
BEGIN
	SELECT COUNT(*) FROM ROW_Admins WHERE Admin_ID = @Username
END
GO


