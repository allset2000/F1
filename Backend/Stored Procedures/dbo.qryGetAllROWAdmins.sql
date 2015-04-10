-- =============================================
-- Author: Santhosh
-- Create date: 03/26/2015
-- Description: SP used to get all Row Users
CREATE PROCEDURE [dbo].[qryGetAllROWAdmins]
AS
BEGIN
	SELECT
		Admin_ID
		, Admin_Password
	FROM ROW_Admins
END
GO


