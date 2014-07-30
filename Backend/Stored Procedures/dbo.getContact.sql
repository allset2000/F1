SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getContact] (
   @ContactType char(1), 
   @UserID varchar(48)
) AS

IF (@ContactType <> 'P')
	SELECT *
	FROM   dbo.Contacts
	WHERE (ContactType <> @ContactType) AND (UserID = @UserID)
  ELSE 
   SELECT *
   FROM  dbo.Contacts
   WHERE (ContactType = @ContactType) AND (UserID = @UserID)
RETURN

GO
