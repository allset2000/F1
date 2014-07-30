SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[qryQueuePermissionsForEditor] (
   @EditorID varchar(50)
) AS
	SELECT *
	FROM   dbo.vwQueuesPermissions 
    WHERE (EditorID = @EditorID) AND (QueueType = EditorType)
RETURN
GO
