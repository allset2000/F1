SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_SEL_CommandCenter_PortalCompanies]

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
