SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_SEL_CommandCenter_UserExists]

	@UserName varchar(50)
	
AS

BEGIN

	SELECT COUNT(*) AS [Exists]
	FROM Security_Users
	WHERE sUserName = @UserName

END


GO
