SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryQueueRestrictionsForEditor] (
   @EditorID varchar(50)
) AS
	SELECT *
	FROM   dbo.vwQueuesRestrictions
    WHERE (EditorID = @EditorID)
RETURN
GO
