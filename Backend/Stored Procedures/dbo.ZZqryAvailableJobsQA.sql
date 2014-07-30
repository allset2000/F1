SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ZZqryAvailableJobsQA] (
   @EditorID varchar(50),
   @StatusStage varchar(50)
)
AS

   IF (@StatusStage = 'Editor')
	SELECT *
	FROM   dbo.vwDictations
    WHERE ([StatusClass] = 'JobAvailable') AND [StatusStage] IN  ('Editor') AND AllocatedToEditorID IN ('', @EditorID)
    ORDER BY AllocatedToEditorID DESC, [Stat] DESC, ReceivedOn ASC
   ELSE 
	SELECT *
	FROM   dbo.vwDictations
    WHERE (([StatusClass] = 'JobAvailable') AND [StatusStage] IN  ('QA1', 'QA2')) AND AllocatedToEditorID IN ('', @EditorID)
    ORDER BY AllocatedToEditorID DESC, [Stat] DESC, ReceivedOn ASC   
RETURN
GO
