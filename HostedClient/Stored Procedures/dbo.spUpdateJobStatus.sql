SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spUpdateJobStatus]  
(  
 @bgintjobId  BIGINT,  
 @vsintJobStatus SMALLINT,
 @vvcrChangedBy VARCHAR(20)  
)  
AS  
BEGIN TRY 
	DECLARE @OldStatus INT
	BEGIN TRANSACTION 
	
	SELECT @OldStatus = status FROM Jobs WHERE jobID = @bgintjobId
	
	UPDATE  Jobs SET Status = @vsintJobStatus,UpdatedDateInUTC=GETUTCDATE() WHERE jobID = @bgintjobId  
	
	-- Only update if the status changed
	IF (@OldStatus <> @vsintJobStatus)
		INSERT INTO Jobstracking(JobID,Status,ChangeDate,ChangedBy)
		VALUES(@bgintjobId,@vsintJobStatus,getdate(),@vvcrChangedBy)
	
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

  
GO
