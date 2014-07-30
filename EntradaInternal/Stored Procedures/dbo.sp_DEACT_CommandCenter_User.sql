SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create PROCEDURE [dbo].[sp_DEACT_CommandCenter_User]

	@uidUserUID varchar(50)
	
AS

BEGIN

	DELETE FROM [EntradaInternal].[dbo].[Security_XREF_AppsUsers]
	WHERE uidUserUID = @uidUserUID

	UPDATE [EntradaInternal].[dbo].[Security_Users]
	   SET [bitActive] = 0, 
		  [dteModified] = GETDATE() 
	 WHERE uidUserUID = @uidUserUID
	

	
END


GO
