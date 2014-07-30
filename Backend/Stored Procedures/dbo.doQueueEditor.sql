SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Juan C. Ruvalcaba
-- =============================================
CREATE PROCEDURE [dbo].[doQueueEditor]
	@queueId smallint, 
	@editorId varchar(50), 
	@priority smallint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @tempQueueId int
SELECT @tempQueueId = QueueID FROM Queue_Editors WHERE QueueID = @queueId AND EditorID = @editorId

IF @tempQueueId IS NULL
BEGIN
	INSERT INTO Queue_Editors
		(QueueID, EditorID, Priority)
	VALUES
		(@queueId,@editorId,@priority)
	SELECT 1 AS Result
END
ELSE
BEGIN
	SELECT 0 AS Result
END
END
GO
