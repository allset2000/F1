
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Stored Procedure

CREATE PROCEDURE [dbo].[doReturnCompleteJob] (
	@JobNumber  varchar(20),
	@GenericPatientFlag bit,
	@Timestamp datetime
) AS 
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;	


			/* Update CompletedOn and other job fields */
			UPDATE [dbo].Jobs
			SET CompletedOn = @Timestamp,
			GenericPatientFlag  = @GenericPatientFlag
			WHERE (JobNumber = @JobNumber)

			 DECLARE @StatusStage varchar(50)
			 SET @StatusStage = [dbo].ftGetJobStatusStage(@JobNumber)

			IF (@StatusStage = 'Editor')
			BEGIN					
				UPDATE [dbo].Jobs
				SET ReturnedOn = @Timestamp
				WHERE (JobNumber = @JobNumber)
			END				 								

			/* Update job status to JobReturned */
		  UPDATE [dbo].JobStatusA
		  SET [Status] = [dbo].ftGetStatusID('JobReturned', [dbo].ftGetJobStatusStage(@JobNumber)),
		  [StatusDate] = @Timestamp
		  WHERE (JobNumber = @JobNumber)

		  INSERT INTO [dbo].[JobTracking]
			([JobNumber], [Status], [StatusDate], [Path])
		  SELECT [JobNumber], [Status], [StatusDate], [Path] 
		  FROM [dbo].JobStatusA
		  WHERE (JobNumber = @JobNumber)

			/* Update job status to JobEditingComplete */
		  UPDATE [dbo].JobStatusA
		  SET [Status] = [dbo].ftGetStatusID('JobEditingComplete', ''),
		  [StatusDate] = @Timestamp
		  WHERE (JobNumber = @JobNumber)

			/* Insert also status JobEditingComplete = 260 in JobTracking table */  
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
