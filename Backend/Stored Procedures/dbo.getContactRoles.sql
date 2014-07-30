SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[getContactRoles] (
   @ContactId int
) AS
	SELECT *
	FROM   dbo.vwContactsRoles
  WHERE (ContactId = @ContactId)
RETURN


GO
