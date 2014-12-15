SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Narender
-- Create date: 12/2/2014
-- Description:	Stored Proc to Read User sign on details from SingleSignOn table based on hashed Credentials
-- =============================================
Create PROCEDURE [dbo].[qrySSOToken]
@userCredentials nvarchar(100)	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [dbo].[SingleSignOn] WHERE [UserCredentials] = @userCredentials
END

GO