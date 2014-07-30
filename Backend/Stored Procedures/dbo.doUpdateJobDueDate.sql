SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[doUpdateJobDueDate] (
	@JobNumber varchar(20),
	@OperationName varchar(20)
) AS 
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		
		DECLARE @JobDueDate datetime
		
		SET @JobDueDate = dbo.ftCalculateJobDueDate(@JobNumber)
		
		
		UPDATE dbo.Jobs
		SET DueDate = @JobDueDate
		WHERE (JobNumber = @JobNumber) AND (ISNULL(DueDate, '1900-01-01') <> @JobDueDate)
				
		IF (@@ROWCOUNT = 1)
		BEGIN
			INSERT INTO dbo.JobDueDateHistory (
				JobNumber, OperationName, JobDueDate, OperationTime
			) VALUES (
				@JobNumber, @OperationName, @JobDueDate, GETDATE()
			)		
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
