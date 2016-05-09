
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		A Raghu
-- Create date: 5/5/2016
-- Description:	Update Backend and hosted job status
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpdateBakendJobStatusByJobNumber]
	@HostedJobNumber  VARCHAR(20),
	@BakendJobNumber VARCHAR(20),
	@NewJobStatus Int,
	@RhythmWorkFlowID Int
AS
BEGIN
	
	BEGIN TRY
		BEGIN TRANSACTION

	    DECLARE @oldJobStatus INT

		Select @oldJobStatus=JobStatus from [Entrada].dbo.Jobs WHERE JobNumber = @BakendJobNumber
		
		IF(@oldJobStatus<>@NewJobStatus)
		  BEGIN  		   
				   UPDATE [Entrada].dbo.Jobs SET 
							JobStatus = @NewJobStatus, 
							ProcessFailureCount = 0, 
							IsLockedForProcessing = 0,
							JobStatusDate = GetDate()
					WHERE JobNumber = @BakendJobNumber

					
					--Anything lower than 280 should be updated on JobStatusA
					UPDATE [Entrada].dbo.JobStatusA SET
							Status = @NewJobStatus,
							StatusDate = GetDate()
					WHERE JobNumber = @BakendJobNumber

					INSERT INTO [Entrada].dbo.JobTracking (JobNumber, Status, StatusDate)
				VALUES(@BakendJobNumber, @NewJobStatus, GetDate())
         END

         UPDATE Jobs SET BackendStatus=@NewJobStatus,UpdatedDateInUTC=GETUTCDATE(),RhythmWorkFlowID=@RhythmWorkFlowID Where JobNumber=@HostedJobNumber


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

END

GO
