SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Raghu A
-- Create date: 7/1/2016
-- Description:	Update error status in job table
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpdateJobErrorStatus]
	@JobID bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--future we will use this Statement
	IF NOT EXISTS (SELECT '*' FROM dbo.Jobs WITH(NOLOCK) WHERE JobID = @JobID AND HasUploadError  = 1)
	BEGIN
		UPDATE Jobs SET HasUploadError  = 1,UpdatedDateInUTC=GETUTCDATE() WHERE JobID = @JobID
 	END
END
GO
