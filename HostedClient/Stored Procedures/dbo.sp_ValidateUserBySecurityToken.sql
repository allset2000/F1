
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_ValidateUserBySecurityToken]
@SecurityToken VARCHAR(100)
AS
BEGIN
      SET NOCOUNT ON;
	
	 SELECT COUNT(*) FROM dbo.UserInvitations U
	                      INNER JOIN dbo.QuickBloxUsers qb ON qb.UserID=u.RegisteredUserId
						  WHERE u.SecurityToken=@SecurityToken
	
END

GO
