SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Dustin Dorsey
-- Create date: 10/16/15
-- Description: Temp SP used mass disable Old Portal users
-- =============================================

CREATE PROCEDURE [dbo].[sp_TFS000_DisableOldPortalUsers] 
(
@UserID Varchar(MAX)
) 

AS 

BEGIN
	
UPDATE Entrada.dbo.Contacts
SET ContactStatus = 'X'
WHERE UserID in (select [Value] from Entradahostedclient.dbo.split(@UserID,','))
	
END

GO
