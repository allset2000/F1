SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_SEL_CommandCenter_Clients_Search]

	@UserUID varchar(50),
	@ClientUID varchar(50),
	@ClientName varchar(300),
	@ClinicID bigint,
	@ClinicCode varchar(20)
AS

BEGIN

	DECLARE @SecLvl int
	
	SELECT @SecLvl = intDefaultSecLevel
	FROM Security_Users SU WITH(NOLOCK) 
	WHERE uidUserUID = @UserUID

-- Users
	IF @SecLvl > 4
		BEGIN
			SELECT SC.[uidClientUID],
				  SC.[intClientID] as [Clinic ID],
				  SC.[sClientCode] as [Clinic Code],
				  SC.[sClientName] as [Account Name],
				  SC.[bitActive] as [Active],
				  SC.[dteCreate] as [Created],
				  SC.[dteModified] as [Modified]
			FROM [EntradaInternal].[dbo].[Security_Clients] SC WITH(NOLOCK)
			WHERE SC.[sClientName] LIKE CASE @ClientName
										WHEN '' THEN SC.[sClientName]
										ELSE (@ClientName + '%')
									END AND
				SC.intClientID = CASE 
										WHEN @ClinicID < 1 THEN SC.intClientID
										ELSE (@ClinicID + '%')
									END AND
				SC.sClientCode = CASE @ClinicCode
										WHEN '' THEN SC.sClientCode
										ELSE (@ClinicCode + '%')
									END 
			ORDER BY SC.[sClientName], 
				SC.bitActive	
		END
	ELSE
		BEGIN
			SELECT SC.[uidClientUID],
				  SC.[intClientID] as [Clinic ID],
				  SC.[sClientCode] as [Clinic Code],
				  SC.[sClientName] as [Account Name],
				  SC.[bitActive] as [Active],
				  SC.[dteCreate] as [Created],
				  SC.[dteModified] as [Modified]
			FROM [EntradaInternal].[dbo].[Security_Clients] SC WITH(NOLOCK)
			INNER JOIN Security_XREF_ClientsUsers XCU WITH(NOLOCK) ON
				SC.uidClientUID = XCU.uidClientUID AND
				XCU.uidClientUID =  @ClientUID
			WHERE SC.bitActive = 1 AND
				SC.sClientName LIKE CASE @ClientName
											WHEN '' THEN SC.sClientName
											ELSE (@ClientName + '%')
										END AND
					SC.intClientID = CASE 
											WHEN @ClinicID < 1 THEN SC.intClientID
											ELSE @ClinicID
										END AND
					SC.sClientCode = CASE @ClinicCode
											WHEN '' THEN SC.sClientCode
											ELSE @ClinicCode
										END AND
					SC.sClientCode = CASE @ClinicCode
											WHEN '' THEN SC.sClientCode
											ELSE (@ClinicCode + '%')
										END 
			ORDER BY SC.[sClientName], 
				SC.bitActive	
		END
END


GO
