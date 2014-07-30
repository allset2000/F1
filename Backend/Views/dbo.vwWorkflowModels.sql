SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwWorkflowModels]
AS
SELECT     ObjectId AS WorkflowModelId, ObjectUniqueKey AS WorkflowModelCode, ObjectName AS WorkflowModelName, ObjectDescription AS WorkflowModelDescription, 
                      ObjectStatus AS WorkflowModelStatus
FROM         dbo.GeneralObjects
WHERE     (ObjectType = 'WorkflowModel') OR
                      (ObjectType = 'Undefined')

GO
