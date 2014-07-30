SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_SEL_CommandCenter_Users_Search]

	@UserUID varchar(50),
	@ClientUID varchar(50),
	@LastName varchar(150),
	@FirstName varchar(150),
	@UserName varchar(50),
	@CompanyUID varchar(300)
AS

BEGIN

	DECLARE @SecLvl int
	
	SELECT @SecLvl = intDefaultSecLevel
	FROM Security_Users SU WITH(NOLOCK) 
	WHERE uidUserUID = @UserUID

-- Users
	IF @SecLvl > 4
		BEGIN
			SELECT SU.[uidUserUID],
				  SU.[sLastName] AS [Last Name],
				  SU.[sFirstName] AS [First Name],
				  SD.[sDepartmentName] as [Department],
				  SU.[bitActive] AS [Active],
				  SU.[sUserName] AS [UserName],
				  SU.[sPwd] AS [Password],
				  SL.sSecurityLevelName AS [Security Level],
				  SU.[dteCreate] AS [Created],
				  SU.[dteModified] as [Modified]
			FROM [EntradaInternal].[dbo].[Security_Users] SU WITH(NOLOCK)
			LEFT OUTER JOIN Security_XREF_ClientsUsers XCU WITH(NOLOCK) ON
				SU.uidUserUID = XCU.uidUserUID
			LEFT OUTER JOIN Security_Clients SC WITH(NOLOCK) ON
				XCU.uidClientUID = SC.uidClientUID 
			LEFT OUTER JOIN Security_Departments SD WITH(NOLOCK) ON
				SU.intDepartmentID = SD.intDepartmentID
			LEFT OUTER JOIN Security_Level SL WITH(NOLOCK) ON
				SU.intDefaultSecLevel = SL.intSecurityLevelID
			WHERE SU.sFirstName LIKE CASE @FirstName
										WHEN '' THEN SU.sFirstName
										ELSE (@FirstName + '%')
									END AND
				SU.sLastName LIKE CASE @LastName
										WHEN '' THEN SU.sLastName
										ELSE (@LastName + '%')
									END AND
				SU.sUserName LIKE CASE @UserName
										WHEN '' THEN SU.sUserName
										ELSE (@UserName + '%')
									END AND
				SC.uidClientUID = CASE @CompanyUID
										WHEN '' THEN SC.uidClientUID
										ELSE @CompanyUID
									END
			ORDER BY SU.sLastName, 
				SU.sFirstName, 
				SU.bitActive	
		END
	ELSE
		BEGIN
			SELECT SU.[uidUserUID],
				  SU.[sLastName] AS [Last Name],
				  SU.[sFirstName] AS [First Name],
				  SD.[sDepartmentName] as [Department],
				  SU.[bitActive] AS [Active],
				  SU.[sUserName] AS [UserName],
				  SU.[sPwd] AS [Password],
				  SL.sSecurityLevelName AS [Security Level],
				  SU.[dteCreate] AS [Created],
				  SU.[dteModified] as [Modified]
			FROM [EntradaInternal].[dbo].[Security_Users] SU WITH(NOLOCK)
			INNER JOIN Security_XREF_ClientsUsers XCU WITH(NOLOCK) ON
				SU.uidUserUID = CASE 
									WHEN @SecLvl > 4 THEN XCU.uidUserUID
									ELSE @UserUID
								END AND
				XCU.uidClientUID = CASE 
									WHEN @SecLvl > 4 THEN XCU.uidClientUID
									ELSE @ClientUID
								END
			INNER JOIN Security_Clients SC WITH(NOLOCK) ON
				XCU.uidClientUID = SC.uidClientUID 		
			LEFT OUTER JOIN Security_Departments SD WITH(NOLOCK) ON
				SU.intDepartmentID = SD.intDepartmentID
			LEFT OUTER JOIN Security_Level SL WITH(NOLOCK) ON
				SU.intDefaultSecLevel = SL.intSecurityLevelID
			WHERE SU.bitActive = 1 AND
				SU.sFirstName LIKE CASE @FirstName
											WHEN '' THEN SU.sFirstName
											ELSE (@FirstName + '%')
										END AND
					SU.sLastName LIKE CASE @LastName
											WHEN '' THEN SU.sLastName
											ELSE (@LastName + '%')
										END AND
					SU.sUserName LIKE CASE @UserName
											WHEN '' THEN SU.sUserName
											ELSE (@UserName + '%')
										END AND
					SC.uidClientUID = CASE @CompanyUID
											WHEN '' THEN SC.uidClientUID
											ELSE @CompanyUID
										END
			ORDER BY SU.sLastName, 
				SU.sFirstName, 
				SU.bitActive	
		END
END


GO
