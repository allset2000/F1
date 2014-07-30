SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Juan C. Ruvalcaba
-- =============================================
CREATE PROCEDURE [dbo].[delQueueDictator]
	@queueId smallint,
	@dictatorId varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

IF @dictatorId <> ''
BEGIN
	DELETE FROM Queue_Dictators WHERE Queue_ID = @queueId AND DictatorID = @dictatorId
	SELECT 2 AS Result
END
ELSE
BEGIN
	SELECT -2 AS Result
END
END
GO
