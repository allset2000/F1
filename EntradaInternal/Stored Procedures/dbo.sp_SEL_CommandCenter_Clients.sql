SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create PROCEDURE [dbo].[sp_SEL_CommandCenter_Clients]

	@UserUID varchar(50),
	@ClientUID varchar(50)
	
AS

BEGIN

	DECLARE @SecLvl int
	
	SELECT @SecLvl = intDefaultSecLevel
	FROM Security_Users SU WITH(NOLOCK) 
	WHERE uidUserUID = @UserUID

-- Client/Company selection
	IF @SecLvl > 4
		BEGIN
			SELECT NULL AS uidClientUID,
				'' AS sClientName
			UNION ALL		
			SELECT SC.uidClientUID,
				SC.sClientName
			FROM Security_Clients SC WITH(NOLOCK)
			WHERE SC.bitActive = 1
			ORDER BY sClientName
		END
	ELSE
		BEGIN
			SELECT NULL AS uidClientUID,
				'' AS sClientName
			UNION ALL
			SELECT SC.uidClientUID,
				SC.sClientName
			FROM Security_Clients SC WITH(NOLOCK)
			INNER JOIN Security_XREF_ClientsUsers XCU WITH(NOLOCK) ON
				SC.uidClientUID = CASE 
									WHEN @SecLvl > 4 THEN XCU.uidClientUID
									ELSE @ClientUID
								END AND
				XCU.uidUserUID = CASE 
									WHEN @SecLvl > 4 THEN XCU.uidUserUID
									ELSE @UserUID
								END
			WHERE SC.bitActive = 1
			ORDER BY sClientName
		END
		


END


GO
