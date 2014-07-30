SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryContactsInRole] (
	@RoleId int
)  AS
		SELECT DISTINCT dbo.Contacts.*
		FROM   dbo.Contacts INNER JOIN dbo.ContactRoles
		ON dbo.Contacts.ContactId = dbo.ContactRoles.ContactId
		WHERE (dbo.ContactRoles.RoleId = @RoleId AND dbo.ContactRoles.RoleStatus <> 'X')
RETURN

GO
