SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Juan C. Ruvalcaba
-- =============================================
CREATE PROCEDURE [dbo].[delQueueEditor]
	@queueId smallint, 
	@editorId varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

IF @editorId <> ''
BEGIN
	DELETE FROM Queue_Editors WHERE QueueID = @queueId AND EditorID = @editorId
	SELECT 2 AS Result
END
ELSE
BEGIN
	SELECT -2 AS Result
END
END
GO
