SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryQueueWorkspacesWellDefined] (
	@ClinicId   [int],
	@DictatorId [int]	
) AS
SELECT DISTINCT 
	   [QueueWorkspaceId] 
      ,[QueueWorkspaceName]
      ,[QueueWorkspacePriorityType]
      ,[QueueId]
      ,[QueueName]
      ,[QueuePriority]
      ,[QueueMemberId]
      ,[ClinicId]
      ,[DictatorId]
      ,[JobsFilter]      
  FROM [dbo].[vwQueueModel]
  WHERE ([QueueWorkspaceId] <> -1 AND [QueueId] <> -1 AND [QueueMemberId]<> -1 AND [EditorIdOk] <> -1 AND EditorStatus = 'A') AND
        (ClinicId = @ClinicId OR DictatorId = @DictatorId)
RETURN
GO
