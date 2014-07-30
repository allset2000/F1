SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getEditorSignOffData] (
   @EditorID varchar(50)
) AS
	SELECT SignOff1, SignOff2, SignOff3
	FROM   dbo.Editors
    WHERE (EditorID = @EditorID)
RETURN
GO
