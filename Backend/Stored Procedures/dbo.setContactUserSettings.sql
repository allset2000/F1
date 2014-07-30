SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[setContactUserSettings] (
	@ContactId int,
	@UserSettings varchar(4096)
) AS 
UPDATE [dbo].[Contacts]
   SET
	  [UserSettings] = @UserSettings
 WHERE ([ContactId] = @ContactId)
GO
