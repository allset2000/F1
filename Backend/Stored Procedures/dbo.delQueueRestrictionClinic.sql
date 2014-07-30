SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Juan C. Ruvalcaba
-- =============================================
CREATE PROCEDURE [dbo].[delQueueRestrictionClinic]
	@queueId smallint,
	@clinicId varchar(50),
	@editorId varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

IF @clinicId > 0
BEGIN
	DELETE FROM Queue_Restrictions WHERE QueueID = @queueId AND ClinicID = @clinicId AND EditorId = @editorId
	SELECT 2 AS Result
END
ELSE
BEGIN
	SELECT 0 AS Result
END
END
GO
