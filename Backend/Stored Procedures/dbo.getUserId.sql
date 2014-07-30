SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[getUserId] (
   @ContactType char(1),
   @UserID varchar(48),
   @Password varchar(48)
) AS

	IF (@ContactType = 'E')
	  BEGIN 
		SELECT *
		FROM  dbo.Contacts
		WHERE ((ContactType = 'E') AND (UserID = @UserID) AND ([Password] = @Password))
		RETURN
	  END
	
    IF ((@ContactType = 'P') AND EXISTS(SELECT * FROM [dbo].[Contacts] 
										WHERE ((ContactType IN ('P','S')) AND (UserID = @UserID) AND ([Password] = ''))))
     BEGIN 
		UPDATE dbo.Contacts
		SET [Password] = @Password,
		ASPMembershipPwd = @Password
		WHERE (ContactType IN ('P', 'S') AND (UserID = @UserID) AND ([Password] = ''))
     END

   SELECT *
   FROM  dbo.Contacts
   WHERE (ContactType IN ('P', 'S') AND (UserID = @UserID) AND ([Password] = @Password))
   
RETURN
GO
