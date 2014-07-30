
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stored Procedure

CREATE PROCEDURE [dbo].[doReturnIncompleteJob] (
	@JobNumber  varchar(20),
	@GenericPatientFlag bit,
	@NextJobStatus smallint,
	@Timestamp datetime
) AS 
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

		DECLARE @NextStatusStage varchar(50)
		SELECT @NextStatusStage = [StatusStage] FROM [dbo].StatusCodes 
		WHERE StatusID = @NextJobStatus

		/* Update Job CC Field */
		UPDATE [dbo].Jobs
		SET ReturnedOn = CASE WHEN 
						ReturnedOn IS NULL
						THEN @Timestamp	-- set incompleted from Editor to QA
						ELSE ReturnedOn -- do nothing, will go to other QA
					  END,
		CompletedOn = CASE WHEN 
						@NextStatusStage = 'QA2' AND CompletedOn IS NULL 
						THEN @Timestamp	-- set completed, will go to CR
						ELSE CompletedOn    -- do nothing, will go to other QA
					  END,
		GenericPatientFlag  = @GenericPatientFlag
		WHERE (JobNumber = @JobNumber)

		/* Update job status to JobReturned in the current status stage */
		UPDATE [dbo].JobStatusA
		SET [Status] = @NextJobStatus,
		 [StatusDate] = @Timestamp
		WHERE (JobNumber = @JobNumber)

		INSERT INTO [dbo].[JobTracking]
		([JobNumber], [Status], [StatusDate], [Path])
		SELECT [JobNumber], [Status], [StatusDate], [Path] 
		FROM [dbo].JobStatusA
		WHERE (JobNumber = @JobNumber)

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
