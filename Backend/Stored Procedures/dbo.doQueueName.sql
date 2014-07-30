SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Andrea B. Estrella S.
-- Mod:			Juan C. Ruvalcaba
-- =============================================
CREATE PROCEDURE [dbo].[doQueueName]	
	@queueID smallint,
	@queueName varchar(100),
	@type tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @tempQueueId int
SELECT @tempQueueId = QueueID FROM Queue_Names WHERE QueueID = @queueID

IF @tempQueueId IS NULL
BEGIN
	DECLARE @qName varchar(100)
	SELECT @qName = QueueName FROM Queue_Names WHERE UPPER(QueueName) = UPPER(@queueName)

	IF @qName IS NULL
	BEGIN		
		DECLARE @lastQueueId int
		SELECT TOP 1 @lastQueueId = QueueID FROM Queue_Names ORDER BY QueueID DESC
		INSERT INTO Queue_Names
			(QueueID, QueueName, [Type])
		VALUES 
			(@lastQueueID+1,@QueueName,@Type)
		SELECT 1 AS Result
	END
	ELSE
	BEGIN
		SELECT -1 AS Result
	END
END
ELSE
BEGIN
	DECLARE @tempQName varchar(100)
	SELECT @tempQName = QueueName FROM Queue_Names WHERE UPPER(QueueName) = UPPER(@queueName)
	
	IF @tempQName IS NULL
	BEGIN
		UPDATE Queue_Names SET QueueName = @queueName, [Type] = @Type WHERE QueueID = @queueID
		SELECT 2 AS Result
	END
	ELSE
	BEGIN
		SELECT -2 AS Result
	END
END
END
GO
