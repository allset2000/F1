SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getEditor] (
   @EditorID varchar(50)
) AS
   SELECT *
   FROM  dbo.vwEditors
   WHERE (EditorID = @EditorID)
RETURN
GO
