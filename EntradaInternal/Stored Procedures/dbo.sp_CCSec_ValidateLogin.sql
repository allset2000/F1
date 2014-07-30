SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 5/15/2012
-- Description:	Validates user-login for Command Center

-- =============================================
CREATE PROCEDURE [dbo].[sp_CCSec_ValidateLogin] 

	@UserName varchar(50),
	@Pwd  varchar(50),
	@AppID varchar(50)

AS
BEGIN

	SELECT SU.uidUserUID, 
		SU.sLastName,
		SU.sFirstName,
		SU.sUserName, 
		SC.uidClientUID,
		SC.sClientName,
		SC.sClientCode,
		SC.intClientID,
		SU.intDefaultSecLevel,
		SL.sSecurityLevelName,
		SU.bitActive, 
		SU.dteCreate, 
		SU.dteModified
	FROM Security_Users SU WITH(NOLOCK)
	INNER JOIN Security_XREF_ClientsUsers XCU WITH(NOLOCK) ON
		SU.uidUserUID = XCU.uidUserUID
	INNER JOIN Security_XREF_AppsUsers XAC WITH(NOLOCK) ON
		XCU.uidUserUID = XAC.uidUserUID
	INNER JOIN Security_Clients SC WITH(NOLOCK) ON
		XCU.uidClientUID = SC.uidClientUID
	INNER JOIN Security_Level SL WITH(NOLOCK) ON
		SU.intDefaultSecLevel = SL.intSecurityLevelID
	--INNER JOIN Entrada.dbo.Clinics C WITH(NOLOCK) ON
	--	SC.intClientID = C.ClinicID
	--INNER JOIN Security_Clients WC WITH(NOLOCK) ON
	--	WCU.uidClientUID = WC.uidClientUID AND
	--	WC.bitActive = 1
	--INNER JOIN Security_Apps WA WITH(NOLOCK) ON
	--	WAC.uidAppUID = WA.uidAppUID AND
	--	WA.bitActive = 1
	WHERE SU.bitActive = 1 AND
		SC.bitActive = 1 AND
		SU.sUserName = @UserName AND
		SU.sPwd = @Pwd
				
END
GO
