SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[setContactChangePasswordToken] (
	@ContactId int,
	@UserID  varchar (48),
    @EMail  varchar (48),
	@SecurityToken  varchar(255)
) AS 
UPDATE [dbo].[Contacts]
   SET
      [SecurityToken] = @SecurityToken
 WHERE ([ContactId] = @ContactId) AND (UserID = @UserID) AND (EMail = @EMail)
GO
