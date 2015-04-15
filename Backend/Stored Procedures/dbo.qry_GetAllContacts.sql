-- =============================================
-- Author: Santhosh
-- Create date: 03/23/2015
-- Description: SP used to obtain all Editors and Portal Users
-- =============================================
CREATE PROCEDURE [dbo].[qry_GetAllContacts]
AS
BEGIN
	SELECT [ContactId]
		  ,CASE WHEN [ContactType] = 'P' Then 'Portal' ELSE 'Editor' END AS [ContactType]
		  ,[FullName]
		  ,[FirstName]
		  ,[MiddleName]
		  ,[LastName]		  
		  ,[EMail]		  
	  FROM [dbo].[Contacts]
	  WHERE (ContactType = 'E' OR ContactType = 'P')
			AND ContactStatus='A'
END


GO


