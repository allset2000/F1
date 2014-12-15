SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Narender
-- Create date: 12/1/2014
-- Description:	Stored Proc to retrieve User sign on details from SingleSignOn table based on token
-- =============================================
CREATE PROCEDURE [dbo].[qrySingleSignOn]
	@ssoToken nvarchar(100)
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT * from [dbo].[SingleSignOn] WHERE [SingleSignOnToken] = @ssoToken
END

GO