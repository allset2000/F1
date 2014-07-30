SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeQueueMember] (
	@QueueMemberId  [int],
	@QueueId  [int],
	@ClinicId [int],
	@DictatorId [int],
	@JobsFilter [varchar] (4000),
	@QueueMemberStatus [char](1) 
) AS 
			
	IF NOT EXISTS(SELECT 1 FROM [dbo].[QueueMembers] WHERE ([QueueMemberId] = @QueueMemberId))
		 BEGIN
			INSERT INTO [dbo].[QueueMembers] (
				[QueueMemberId], [QueueId], [ClinicId], [DictatorId], [JobsFilter], QueueMemberStatus 
			) VALUES (
				@QueueMemberId, @QueueId, @ClinicId, @DictatorId, @JobsFilter, @QueueMemberStatus 
			)
		 END
	ELSE 
		 BEGIN
			UPDATE [dbo].[QueueMembers] 
			 SET
				 [JobsFilter] = @JobsFilter,
				 [QueueMemberStatus] = @QueueMemberStatus  
			WHERE 
			(([QueueMemberId] = @QueueMemberId) AND ([ClinicId] = @ClinicId) AND ([DictatorId] = @DictatorId))
		END
GO
