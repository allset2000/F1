SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create PROCEDURE [dbo].[sp_XREF_CommandCenter_PortalReport_SEL_Companies]

	@UserUID varchar(50)
	
AS

BEGIN

	DECLARE @SecLvl int
	
	SELECT @SecLvl = intDefaultSecLevel
	FROM Security_Users SU WITH(NOLOCK) 
	WHERE uidUserUID = @UserUID

-- Client/Company selection
	IF @SecLvl > 4
		BEGIN
			SELECT [CompanyId],
				  [CompanyName],
				  [CompanyCode]
			FROM [Entrada].[dbo].[DSGCompanies] C WITH(NOLOCK)
			ORDER BY [CompanyName]
		END



END


GO
