SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ZZqryEditorAssignedJobsEdit0] (
   @EditorID varchar(50)
)
AS 

  SELECT *
  FROM   dbo.vwDictations
  WHERE (  ( (EditorID = @EditorID AND StatusStage = 'Editor') OR 
             (EditorID_QA1 = @EditorID AND StatusStage = 'QA1') OR 
             (EditorID_QA2 = @EditorID AND StatusStage = 'QA2') ) 
         AND ([StatusClass] = 'JobDownloaded'))
RETURN
GO
