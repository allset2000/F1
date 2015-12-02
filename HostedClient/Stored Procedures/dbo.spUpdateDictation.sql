SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************  
** File:  spUpdateDictation.sql  
** Name:  spUpdateDictation  
** Desc:  Update the dictation and if status changed then insert into Dictationstracking table 
** Auth:  Suresh  
** Date:  18/May/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/
  
CREATE PROCEDURE [dbo].[spUpdateDictation]  
(
 @bgintJobID BIGINT,  
 @bgintDictationID  BIGINT,
 @vintDictationTypeID int,
 @vintDictatorID int,
 @vintQueueID int,
 @smintDuration smallint,
 @vvcrMachineName varchar(50),
 @vvcrFileName VARCHAR(255),
 @vvcrClientVersion VARCHAR(100),
 @vvcrChangedBy VARCHAR(20),
 @vintStatus  SMALLINT 
)  
AS  
BEGIN TRY 
	DECLARE @OldDictationStatus INT,
			@OldJobStatus INT,
			@newJobStatus INT
	BEGIN TRANSACTION 
	
	SELECT @OldDictationStatus = status FROM Dictations WHERE DictationID = @bgintDictationID 
	SELECT @OldJobStatus = status FROM Jobs WHERE jobID = @bgintJobID 
	
	UPDATE Dictations SET [FileName] = @vvcrFileName,status=@vintStatus,JobID=@bgintJobID,DictationTypeID=@vintDictationTypeID,DictatorID=@vintDictatorID,
		   QueueID=@vintQueueID,Duration=@smintDuration,MachineName=@vvcrMachineName,UpdatedDateInUTC=GETUTCDATE()
	WHERE DictationID = @bgintDictationID  
	
	-- Only update if the status changed
	IF (@OldDictationStatus <> @vintStatus)
		INSERT INTO DictationsTracking(DictationID,Status,ChangeDate,ChangedBy)
		VALUES(@bgintDictationID,@vintStatus,getdate(),@vvcrChangedBy)

	SELECT @newJobStatus = status FROM Jobs WHERE jobID = @bgintJobID 

	-- Changing the dictation status may have changed the job status
    -- (via the trigger), so we may need to insert a tracking row
	IF (@OldJobStatus <> @newJobStatus)
		INSERT INTO Jobstracking(JobID,Status,ChangeDate,ChangedBy)
		VALUES(@bgintjobId,@newJobStatus,getdate(),@vvcrChangedBy)	
			
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
