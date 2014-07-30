SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create PROCEDURE [dbo].[sp_UPD_CommandCenter_Clients]

	@uidClientUID varchar(150),
	@intClientID bigint,
	@sClientCode varchar(20),
	@sClientName varchar(300),
	@bitActive bit
	
AS

BEGIN

	UPDATE [EntradaInternal].[dbo].[Security_Clients]
	SET [intClientID] = @intClientID, 
	   [sClientCode] = @sClientCode, 
	   [sClientName] = @sClientName, 
	   [bitActive] = @bitActive, 
	   [dteModified] = GETDATE()
	WHERE [EntradaInternal].[dbo].[Security_Clients].uidClientUID = @uidClientUID

			   
END


GO
