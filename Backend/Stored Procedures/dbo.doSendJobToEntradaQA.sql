SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[doSendJobToEntradaQA] (
	@JobNumber  varchar(20),
	@Timestamp datetime
) AS 
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;		
		
		UPDATE [dbo].JobStatusA
		SET [Status] = [dbo].ftGetStatusID('JobAvailable', 'QA1'),
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
