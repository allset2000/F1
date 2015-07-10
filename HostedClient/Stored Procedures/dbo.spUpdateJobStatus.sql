/******************************  
** File:  spUpdateJobStatus.sql  
** Name:  spUpdateJobStatus  
** Desc:  Update the Status in jobs table and if status changed then insert into Jobstraking table 
** Auth:  Suresh  
** Date:  18/May/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
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
	
	UPDATE  Jobs SET Status = @vsintJobStatus WHERE jobID = @bgintjobId  
	
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

  