SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[doReleaseJob] (
	 @JobNumber  varchar(20),
	 @Timestamp datetime
) AS 
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			DECLARE @jobStatusStage varchar(50);
    
			SET @jobStatusStage = [dbo].ftGetJobStatusStage(@JobNumber);
    
			/* Update Job Status to JobAvailable */
			UPDATE [dbo].JobStatusA
			SET [Status] = [dbo].ftGetStatusID('JobAvailable', @jobStatusStage),
			[StatusDate] = @Timestamp
			WHERE (JobNumber = @JobNumber)

			INSERT INTO [dbo].[JobTracking]
			([JobNumber], [Status], [StatusDate], [Path])	
			SELECT [JobNumber], [Status], [StatusDate], [Path] 
			FROM [dbo].JobStatusA
			WHERE (JobNumber = @JobNumber)
    
			/* Update job Editor and ReturnedOn for QA to nulls */
			IF (@jobStatusStage = 'Editor') 
			BEGIN
				UPDATE [dbo].Jobs
				SET EditorID = NULL,
				ReturnedOn = NULL
				WHERE (JobNumber = @JobNumber)
			END			
	
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
		   BEGIN
			ROLLBACK TRANSACTION
							DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
							SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
			RAISERROR(@ErrMsg, @ErrSeverity, 1)
		   END
	END CATCH
	RETURN
END
GO
