SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[doAssignJobToEditor] (
   @JobNumber varchar(20),
   @EditorID varchar(50),
   @Timestamp datetime
) AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		DECLARE @jobStatusStage varchar(50);
	    
		SET @jobStatusStage = [dbo].ftGetJobStatusStage(@JobNumber);
    
		/* Update job status to JobDownloaded */
		UPDATE [dbo].JobStatusA
		SET [Status] = [dbo].ftGetStatusID('JobDownloaded', @jobStatusStage),
		[StatusDate] = @Timestamp
		WHERE (JobNumber = @JobNumber)

		INSERT INTO [dbo].[JobTracking]
		([JobNumber], [Status], [StatusDate], [Path])		
		SELECT [JobNumber], [Status], [StatusDate], [Path] 
		FROM [dbo].JobStatusA
		WHERE (JobNumber = @JobNumber)

		/* Assign job to editor */
		IF (@jobStatusStage = 'Editor') 
			BEGIN
				UPDATE [dbo].Jobs
				SET EditorID = @EditorID
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
