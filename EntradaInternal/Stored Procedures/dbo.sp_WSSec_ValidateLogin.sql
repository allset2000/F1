SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 5/03/2012
-- Description:	Validates user-login in applications
--		that rely on web services for data.
-- =============================================
CREATE PROCEDURE [dbo].[sp_WSSec_ValidateLogin] 

	@UserName varchar(50),
	@Pwd  varchar(50)


AS
BEGIN

	SELECT WU.uidUserUID
	FROM Security_Users WU WITH(NOLOCK)
	INNER JOIN WebServicesSecurity_XREF_ClientsUsers WCU WITH(NOLOCK) ON
		WU.uidUserUID = WCU.uidUserUID
	INNER JOIN WebServicesSecurity_XREF_AppsClients WAC WITH(NOLOCK) ON
		WCU.uidClientUID = WAC.uidClientUID
	INNER JOIN Security_Clients WC WITH(NOLOCK) ON
		WCU.uidClientUID = WC.uidClientUID AND
		WC.bitActive = 1
	INNER JOIN Security_Apps WA WITH(NOLOCK) ON
		WAC.uidAppUID = WA.uidAppUID AND
		WA.bitActive = 1
	WHERE WU.bitActive = 1 AND
		WU.sUserName = @UserName AND
		WU.sPwd = @Pwd
				
END
GO
