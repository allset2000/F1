SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwWorkflowStates]
AS
SELECT     ObjectId AS WorkflowStateId, ObjectUniqueKey AS StateCode, ObjectName AS StateName, ObjectDescription AS StateDescription, ObjectStrValue1 AS EditionStage, 
                      ObjectStatus AS WorkflowStateStatus, ObjectStrValue2 AS QAStage
FROM         dbo.GeneralObjects
WHERE     (ObjectType = 'WorkflowState') OR
                      (ObjectType = 'Undefined')

GO
