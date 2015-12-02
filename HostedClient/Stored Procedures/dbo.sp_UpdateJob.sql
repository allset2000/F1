SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 8/11/2015
-- Description: SP used to update a job record
-- Application Usage: DictateAPI
-- Note : Modified on 9/9/2015 for updating the jobtypeid
-- =============================================
  
CREATE PROCEDURE [dbo].[sp_UpdateJob]  
(
	@JobId int,
	@Status smallint,
	@Stat bit,
	@Priority smallint,
	@ChangedBy varchar(200),
	@AdditonalData varchar(max) = '',
	@JobTypeID int
)  
AS  
BEGIN TRY 
	DECLARE @OldStatus smallint,
			@OldStat bit,
			@OldPriority smallint,
			@OldAdditionalData varchar(max),
			@OldJobTypeID int

	BEGIN TRANSACTION 
	
	SELECT @OldStatus = Status, @OldStat = Stat, @OldPriority = Priority, @OldAdditionalData = AdditionalData, @OldJobTypeID = JobTypeID  from Jobs where JobID = @JobId

	IF (@Status <> @OldStatus)
	BEGIN
		UPDATE Jobs SET Status = @Status,UpdatedDateInUTC=GETUTCDATE() where JobId = @JobId

		INSERT INTO Jobstracking(JobID,Status,ChangeDate,ChangedBy) VALUES(@JobId, @Status, GETDATE(), @ChangedBy)
	END

	IF (@Stat <> @OldStat)
	BEGIN
		UPDATE Jobs SET Stat = @Stat,UpdatedDateInUTC=GETUTCDATE() where JobId = @JobId
	END

	IF (@Priority <> @OldPriority)
	BEGIN
		UPDATE Jobs SET Priority = @Priority,UpdatedDateInUTC=GETUTCDATE() where JobId = @JobId
	END
			
	IF (@OldAdditionalData is null or @AdditonalData <> @OldAdditionalData)
	BEGIN
		UPDATE Jobs SET AdditionalData = @AdditonalData,UpdatedDateInUTC=GETUTCDATE() where JobId = @JobId
	END

	IF (@JobTypeID  <> @OldJobTypeID)
	BEGIN
		UPDATE Jobs SET JobTypeID = @JobTypeID,UpdatedDateInUTC=GETUTCDATE() where JobId = @JobId
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

  
GO
