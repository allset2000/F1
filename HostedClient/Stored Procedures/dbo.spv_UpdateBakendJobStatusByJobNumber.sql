
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
	@BakendJobNumber VARCHAR(20),
	@NewJobStatus Int,
	@RhythmWorkFlowID Int,
	@UserID INT
AS
BEGIN
	
	BEGIN TRY
		BEGIN TRANSACTION

	    DECLARE @oldJobStatus INT

		DECLARE @UserName VARCHAR(50)

		SELECT @UserName=UserName FROM Dbo.USERS WITH(NOLOCK) WHERE USERID=@UserID

		SELECT @oldJobStatus=JobStatus FROM [dbo].[EN_Jobs] WHERE JobNumber = @BakendJobNumber
		
		IF(@oldJobStatus<>@NewJobStatus)
		  BEGIN  		   
				   UPDATE [dbo].[EN_Jobs] SET 
							JobStatus = @NewJobStatus, 
							ProcessFailureCount = 0, 
							IsLockedForProcessing = 0,
							JobStatusDate = GetDate()
					WHERE JobNumber = @BakendJobNumber

					
					--Anything lower than 280 should be updated on JobStatusA
					UPDATE [dbo].[EN_JobStatusA] SET
							Status = @NewJobStatus,
							StatusDate = GetDate()
					WHERE JobNumber = @BakendJobNumber

					INSERT INTO [dbo].[EN_JobTracking] (JobNumber, Status, StatusDate)
				    VALUES(@BakendJobNumber, @NewJobStatus, GetDate())

					   INSERT INTO [dbo].[EN_Job_History]
								(JOBNUMBER, MRN, JOBTYPE, CurrentStatus , UserId, HistoryDateTime, FIRSTNAME, MI, LASTNAME, DOB, ISHISTORY, STAT,IsFromMobile) 
					   SELECT 
						  TOP 1 JOBNUMBER, MRN, JOBTYPE, @NewJobStatus ,@UserName, GETDATE(), FIRSTNAME, MI, LASTNAME, DOB, ISHISTORY, STAT, 1 
					   FROM [dbo].[EN_Job_History]
					   WHERE JobNumber = @BakendJobNumber ORDER BY JobHistoryID DESC

         END

         UPDATE J SET BackendStatus=@NewJobStatus,UpdatedDateInUTC=GETUTCDATE(),RhythmWorkFlowID=@RhythmWorkFlowID 
		 FROM dbo.Jobs J
		 INNER JOIN [dbo].[EN_Jobs_Client] JC on Jc.FileName=j.JobNumber
		 WHERE JC.JobNumber=@BakendJobNumber

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
