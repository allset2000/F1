SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeQueueOrphanJob] (
	@ClinicId  [int],
	@DictatorId  [int],
	@JobType  [varchar]  (100),
	@Stat  [bit],
	@JobsCount  [int]
) AS 

IF NOT EXISTS( SELECT 1 FROM [dbo].[QueuesOrphanJobs] 
			   WHERE ([ClinicId] = @ClinicId) AND ([DictatorId] = @DictatorId) AND 
			         ([JobType] = @JobType) AND ([Stat] = @Stat)
			  )
	 BEGIN
	    IF (@JobsCount <> 0)
			BEGIN
			INSERT INTO [dbo].[QueuesOrphanJobs] (
				[ClinicId], [DictatorId], [JobType], [Stat], [JobsCount] 
			) VALUES (
				@ClinicId, @DictatorId, @JobType, @Stat, @JobsCount 
			)
		END
	 END
ELSE 
	 BEGIN
		IF (@JobType <> '') 
			UPDATE [dbo].[QueuesOrphanJobs] 
			SET 		-- If JobsCount = 0 then already exists one or more queueing rules for specified data
			 [JobsCount] = CASE @JobsCount WHEN 0 THEN 0 ELSE [JobsCount] + @JobsCount END
			WHERE  ([ClinicId] = @ClinicId) AND ([DictatorId] = @DictatorId) AND 
				   ([JobType] = @JobType) AND ([Stat] = @Stat)
		ELSE
			UPDATE [dbo].[QueuesOrphanJobs] 
			SET 		-- If JobsCount = 0 then already exists one or more queueing rules for specified data
			 [JobsCount] = CASE @JobsCount WHEN 0 THEN 0 ELSE [JobsCount] + @JobsCount END
			WHERE  ([ClinicId] = @ClinicId) AND ([DictatorId] = @DictatorId) AND ([Stat] = @Stat)
			
	END
GO
