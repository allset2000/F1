SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create PROCEDURE [dbo].[sp_UPD_CommandCenter_User]

	@uidUserUID varchar(50),
	@sLastName varchar(150),
	@sFirstName varchar(150),
	@bitActive bit,
	@sUserName varchar(50),
	@sPwd varchar(50),
	@intDefaultSecLevel int	
	
AS

BEGIN

	UPDATE [EntradaInternal].[dbo].[Security_Users]
	   SET [sLastName] = @sLastName, 
		  [sFirstName] = @sFirstName, 
		  [bitActive] = @bitActive, 
		  [sUserName] = @sUserName, 
		  [sPwd] = @sPwd, 
		  [intDefaultSecLevel] = @intDefaultSecLevel, 
		  [dteModified] = GETDATE() 
	 WHERE uidUserUID = @uidUserUID
	

END


GO
