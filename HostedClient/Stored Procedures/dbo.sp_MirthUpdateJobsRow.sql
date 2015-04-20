
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 3/11/2015
-- Description: SP used by mirth to update jobs_row status column
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
