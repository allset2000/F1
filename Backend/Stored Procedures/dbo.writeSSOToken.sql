SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Narender
-- Create date: 12/1/2014
-- Description:	Stored Proc to insert single sign token into SingleSignOn table
-- =============================================
CREATE PROCEDURE [dbo].[writeSSOToken]
@ssoToken nvarchar(100),
@userCredentials nvarchar(100)	
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT * FROM [dbo].[SingleSignOn] WHERE [UserCredentials] = @userCredentials)
	BEGIN
	INSERT INTO [dbo].[SingleSignOn] ([SingleSignOnToken],[UserCredentials]) VALUES (@ssoToken,@userCredentials)
	END
END

GO