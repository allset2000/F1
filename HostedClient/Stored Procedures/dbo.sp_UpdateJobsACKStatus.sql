SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 8/25/2015
-- Description: SP used to insert / update a row into the jobs_row table
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateJobsACKStatus] (
	 @JobId int,
	 @ACKStatus int,
	 @MessageId varchar(100) = ''
) AS 
BEGIN

	IF @MessageId <> ''
	BEGIN
		UPDATE Jobs_Row set AckStatus = @ACKStatus, AckMessageID = @MessageId, ChangedDate = GETDATE() WHERE JobID = @JobId
	END
	ELSE
	BEGIN
		UPDATE Jobs_Row set AckStatus = @ACKStatus, ChangedDate = GETDATE() WHERE JobID = @JobId
	END

END


GO
