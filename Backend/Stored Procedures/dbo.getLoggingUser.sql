SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		Juan C. Ruvalcaba
-- =============================================
CREATE PROCEDURE [dbo].[getLoggingUser]
	@userName nvarchar(32),
	@userPassword nvarchar(32)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT     Username, [Password], UserId, CompanyId FROM DSGUsers
WHERE     (Username = @userName) AND ([Password] = @userPassword)

END


GO
