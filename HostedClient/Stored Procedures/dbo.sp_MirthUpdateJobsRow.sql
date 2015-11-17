SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 3/11/2015
-- Description: SP used by mirth to update jobs_row status column
--11/17/2015 Mike Cardwell - Added logic to create an entry in Jobs_Row when one doesnt exist
-- =============================================
CREATE PROCEDURE [dbo].[sp_MirthUpdateJobsRow] (
	@JobId int = null,
	@AckStatus int = null,
	@RowStatus int = null,
	@MessageTotal int = null,
	@AckMessageId varchar(50) = null
) AS 
BEGIN

	IF (@JobId is null)
	BEGIN
		return
	END

	IF NOT EXISTS (Select jobid from Jobs_Row WHERE JobId = @JobID)
	BEGIN
		INSERT INTO Jobs_Row (JobID, CreateDate, ChangedDate) Values (@JobID, GETDATE(), GETDATE())
	END

	IF (@MessageTotal is not null)
	BEGIN
		UPDATE Jobs_Row SET MessageTotal=@MessageTotal, ChangedDate = GETDATE() WHERE JobID = @JobId
	END

	IF (@RowStatus is not null)
	BEGIN
		UPDATE Jobs_Row SET ROWStatus = @RowStatus, ChangedDate = GETDATE() WHERE JobID = @JobId
	END
		
	IF (@AckStatus is not null)
	BEGIN
		UPDATE Jobs_Row SET AckStatus = @AckStatus, ChangedDate = GETDATE() WHERE JobID = @JobId
	END

	IF (@MessageTotal is not null)
	BEGIN
		UPDATE Jobs_Row SET MessageTotal = @MessageTotal, ChangedDate = GETDATE() WHERE JobID = @JobId
	END

	IF (@AckMessageId is not null)
	BEGIN
		UPDATE Jobs_Row SET AckMessageID = @AckMessageId, ChangedDate = GETDATE() WHERE JobID = @JobId
	END

END


GO
