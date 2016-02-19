
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
	@JobId INT,
	@Status SMALLINT,
	@Stat BIT,
	@Priority SMALLINT,
	@ChangedBy VARCHAR(200),
	@AdditonalData VARCHAR(max) = '',
	@JobTypeID INT
)  
AS  
BEGIN TRY 
	DECLARE @OldStatus SMALLINT,
			@OldStat BIT,
			@OldPriority SMALLINT,
			@OldAdditionalData VARCHAR(MAX),
			@OldJobTypeID INT

    SET NOCOUNT ON;

	BEGIN TRANSACTION 
	
			SELECT @OldStatus = [Status], 
				   @OldStat = Stat, 
				   @OldPriority = [Priority], 
				   @OldAdditionalData = AdditionalData, 
				   @OldJobTypeID = JobTypeID 
			FROM Jobs 
			WHERE JobID = @JobId

			UPDATE Jobs 
				SET [Status] = CASE WHEN @Status <> @OldStatus THEN @Status ELSE [Status] END,
					Stat = CASE WHEN @Stat <> @OldStat THEN @Stat ELSE [Stat] END,
					[Priority] = CASE WHEN @Priority <> @OldPriority THEN @Priority ELSE [Priority] END,
					AdditionalData = CASE WHEN (@OldAdditionalData IS NULL OR (@AdditonalData <> @OldAdditionalData)) THEN @AdditonalData ELSE AdditionalData END,
					JobTypeID = CASE WHEN @JobTypeID  <> @OldJobTypeID THEN JobTypeID ELSE JobTypeID END,
					UpdatedDateInUTC=GETUTCDATE() 
			WHERE JobId = @JobId

			IF (@Status <> @OldStatus)
			BEGIN
				--UPDATE Jobs SET Status = @Status,UpdatedDateInUTC=GETUTCDATE() where JobId = @JobId
				INSERT INTO Jobstracking
				       (JobID,[Status],ChangeDate,ChangedBy) 
				VALUES (@JobId, @Status, GETDATE(), @ChangedBy)

			END
--Commented By Raghu
	--IF (@Stat <> @OldStat)
	--BEGIN
	--	UPDATE Jobs SET Stat = @Stat,UpdatedDateInUTC=GETUTCDATE() where JobId = @JobId
	--END

	--IF (@Priority <> @OldPriority)
	--BEGIN
	--	UPDATE Jobs SET Priority = @Priority,UpdatedDateInUTC=GETUTCDATE() where JobId = @JobId
	--END
			
	--IF (@OldAdditionalData is null or @AdditonalData <> @OldAdditionalData)
	--BEGIN
	--	UPDATE Jobs SET AdditionalData = @AdditonalData,UpdatedDateInUTC=GETUTCDATE() where JobId = @JobId
	--END

	--IF (@JobTypeID  <> @OldJobTypeID)
	--BEGIN
	--	UPDATE Jobs SET JobTypeID = @JobTypeID,UpdatedDateInUTC=GETUTCDATE() where JobId = @JobId
	--END

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 
	   BEGIN
			ROLLBACK TRANSACTION
			--Commented By Raghu
			--DECLARE @ErrMsg nvarchar(4000), @ErrSeverity INT
			--SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
			DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), 
		            @ErrSeverity INT= ERROR_SEVERITY()
			RAISERROR(@ErrMsg, @ErrSeverity, 1)
		END
END CATCH 

  
GO
