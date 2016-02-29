SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--x history:
--x_____________________________________________________________________________
--x  ver   |    date     |  by                 |  comments - include ticket#
--x_____________________________________________________________________________
--x   0    | 02/29/2016  | sharif shaik        | Update Job Status once deliver all the images for the Job
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
/*
	set statistics io on
	exec sp_JobStatusUpdateForImageOnly 5751438, 450, 'Image Only by EL'

*/

CREATE PROCEDURE [dbo].[sp_JobStatusUpdateForImageOnly] 
	@JobID BIGINT,	
	@JobStatus SMALLINT,
	@ChangedBy VARCHAR(50) 
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY 

	BEGIN TRANSACTION 

		-- Number of images pending to be delivered
		-- If the count is 0 then all images are delivered. If > 0, then some images are not delivered
		DECLARE @ImagePendingCount INT
		DECLARE @OldStatus INT
	
		SELECT @ImagePendingCount = COUNT(1) FROM JobImages JI
		LEFT OUTER JOIN JobsDeliveryTracking JDT
			  ON JI.ImageID = JDT.ImageID
		WHERE JI.JobID = @JobID 
			  AND JDT.ImageID IS NULL

		IF (@ImagePendingCount = 0)
		BEGIN
			SELECT @OldStatus = [Status] FROM Jobs WHERE JobID = @JobID

			-- Only update if the status changed
			IF (@OldStatus <> @JobStatus)
			BEGIN
				UPDATE  Jobs 
				SET [Status] = @JobStatus, UpdatedDateInUTC=GETUTCDATE() 
				WHERE jobID = @JobID  

				INSERT INTO Jobstracking(JobID, [Status], ChangeDate, ChangedBy)
				VALUES(@JobID, @JobStatus, GETDATE(), @ChangedBy)
			END
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

END
GO
