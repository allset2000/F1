SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryEditorAssignedJobs] (
   @EditorID varchar(50)
)
AS 
  SELECT *
  FROM   dbo.vwMedicalJobs
  WHERE ([StatusClass] = 'JobDownloaded') AND (CurrentlyEditedByID = @EditorID)
RETURN
GO
