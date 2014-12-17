SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author     : Narender
-- Create date: 12/17/2014
-- Description:	This proc is to delete token which is expired
-- =============================================
ALTER PROCEDURE [dbo].[delSSOToken] 
	@ssoToken nvarchar(100)
AS
BEGIN
		DELETE FROM [dbo].[SingleSignOn] WHERE [SingleSignOnToken] = @ssoToken 
END