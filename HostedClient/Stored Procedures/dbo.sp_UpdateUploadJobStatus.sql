
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Raghu A
-- Create date: 08/02/2015
-- Description: SP used to update a job record
-- Application Usage: DictateAPI
-- =============================================  
CREATE PROCEDURE [dbo].[sp_UpdateUploadJobStatus]  
(
	@JobId INT,
	@Status SMALLINT,
	@Stat BIT,
	@JobTypeID INT,
	@OwnerUserID INT,
	@MessageThreadID VARCHAR(10),
	@TagMetaData VARCHAR(2000),
	@HasTagMetaData SMALLINT,
	@HasImages SMALLINT,
	@HasDictation SMALLINT,
	@HasChatHistory SMALLINT,
	@OwnerDictatorID INT,
	@ChangedBy VARCHAR(200)
)  
AS  
BEGIN TRY 
	DECLARE @OldStatus SMALLINT,
			@OldStat BIT,
			@OldJobTypeID INT

    SET NOCOUNT ON;

	BEGIN TRANSACTION 
	    
	  
			SELECT @OldStatus = [Status], @OldStat = Stat, 
				    @OldJobTypeID = JobTypeID 
			FROM dbo.Jobs 
			WHERE JobID = @JobId

			UPDATE dbo.Jobs 
				SET [Status] = CASE WHEN @Status <> @OldStatus THEN @Status ELSE [Status] END,
					Stat = CASE WHEN @Stat <> @OldStat THEN @Stat ELSE [Stat] END,				
					JobTypeID = CASE WHEN @JobTypeID  <> @OldJobTypeID THEN @JobTypeID ELSE JobTypeID END,
					OwnerUserID=@OwnerUserID,
					HasDictation=@HasDictation,
					HasImages=@HasImages,
					HasChatHistory=@HasChatHistory,
					HasTagMetaData=@HasTagMetaData,
					TagMetaData=@TagMetaData,
					OwnerDictatorID=@OwnerDictatorID,						
					ChatHistory_ThreadID=CASE WHEN ISNULL(@MessageThreadID,'')='' THEN NULL ELSE CAST(@MessageThreadID AS INT) END,
					UpdatedDateInUTC=GETUTCDATE() 
			WHERE JobId = @JobId

			IF (@Status <> @OldStatus)
			BEGIN				
				INSERT INTO dbo.Jobstracking
				       (JobID,[Status],ChangeDate,ChangedBy) 
				VALUES (@JobId, @Status, GETDATE(), @ChangedBy)

			END

       --If upload is image only or chat history only then change status to 390 (In Delivery) status
		IF((@HasImages=1 OR @HasChatHistory=1) AND @HasDictation=0 )
		   BEGIN		      
				  SET @OldStatus=@Status

				  SET @Status=390

				  UPDATE dbo.Jobs SET [Status]=@Status WHERE JobId = @JobId
			  
					IF (@Status <> @OldStatus)
					BEGIN				
						INSERT INTO dbo.Jobstracking
							   (JobID,[Status],ChangeDate,ChangedBy) 
						VALUES (@JobId, @Status, GETDATE(), @ChangedBy)

					END
		   END		  

	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 
	   BEGIN
			ROLLBACK TRANSACTION			
			DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(), 
		            @ErrSeverity INT= ERROR_SEVERITY()
			RAISERROR(@ErrMsg, @ErrSeverity, 1)
		END
END CATCH 


  
GO
