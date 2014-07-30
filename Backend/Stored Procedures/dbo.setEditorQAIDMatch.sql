SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[setEditorQAIDMatch] (
	@EditorID varchar (50),
	@EditorQAIDMatch  varchar (50)
) AS 
	UPDATE [dbo].[Editors] 
	SET EditorQAIDMatch = @EditorQAIDMatch
	WHERE ([EditorID] = @EditorID)
GO
