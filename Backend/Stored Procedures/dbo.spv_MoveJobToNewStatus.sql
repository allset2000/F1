
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Vivek>
-- Create date: <5/4/2016>
-- Description:	<Proc to Move JobStatus on backend DB>
--				Designed only for 280-->345, 280-->354 and 345-->354. To be called from EL and Downloader.
--				Can be used for other status movement but check the code and test it.
--exec spv_MoveJobToNewStatus '2016050500000002',354
--X HISTORY:
--X_____________________________________________________________________________
--X  VER   |    DATE      |  BY						|  COMMENTS - include Ticket#
--X_____________________________________________________________________________
--X   0    | 05/04/2016   | Vivek					| Initial Design
--X   1    | 05/09/2016   | Naga					| Fixed the where clause on 354 status validation
-- =============================================
CREATE PROCEDURE [dbo].[spv_MoveJobToNewStatus] 
	@JobNumber varchar(20),
	@NewJobStatus smallint
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @CurrentJobStatus smallint
	DECLARE @Path varchar(200)	--JobTracking takes 255 but JobStatusA and JobStatusB has only 200.

	--Set to 354 (delivery success) only if there is nothing more to deliver
	IF (@NewJobStatus=354 AND EXISTS(SELECT 1 FROM JobsToDeliver WHERE JobNumber=@JobNumber))
		RETURN;

	SELECT @CurrentJobStatus = Status, @Path = Path from JobstatusB WHERE JobNumber=@JobNumber 

	-- status hasn't changed so nothing to update
	IF @CurrentJobStatus = @NewJobStatus 
		RETURN;

	--Designed only for 280-->345, 280-->354 and 345-->354. To be called from EL and Downloader.
	--Can be used for other status movement but check the code and test it.
	--Once it goes to 360, no change after that since 360 is the final stage for now. Might change in future.
	IF (@NewJobStatus NOT IN(345,354) or @CurrentJobStatus = 360)
		RETURN; 

	BEGIN TRY
		BEGIN TRANSACTION

			UPDATE Jobs SET 
					JobStatus = @NewJobStatus, 
					ProcessFailureCount = 0, 
					IsLockedForProcessing = 0,
					JobStatusDate = GetDate()
			WHERE JobNumber = @JobNumber

			--Updates Only JobStatusB since the proc handles only 345 and 354. 
			--Anything lower than 280 should be updated on JobStatusA
			UPDATE JobStatusB SET
					Status = @NewJobStatus,
					StatusDate = GetDate()
			WHERE JobNumber = @JobNumber

			INSERT INTO JobTracking (JobNumber, Status, StatusDate, Path)
				VALUES(@JobNumber, @NewJobStatus, GetDate(), @Path)
				     

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
