SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Juan C. Ruvalcaba
-- =============================================
CREATE PROCEDURE [dbo].[doQueueRestrictions]
	@queueId smallint,
	@editorID varchar(50),
	@clinicID smallint, 
	@location smallint, 
	@dictatorID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @tempQueueIdClinic int, @tempQueueIdDictator int
SELECT @tempQueueIdClinic = QueueID FROM Queue_Restrictions WHERE QueueID = @queueId AND ClinicID = @clinicID AND EditorID = @editorID
SELECT @tempQueueIdDictator = QueueID FROM Queue_Restrictions WHERE QueueID = @queueId AND DictatorID = @dictatorID AND EditorID = @editorID

IF @queueId > 0
BEGIN
	IF @tempQueueIdClinic IS NULL OR @tempQueueIdDictator IS NULL
	BEGIN
		INSERT INTO Queue_Restrictions
			(QueueID, EditorID, ClinicID, Location, DictatorID)
		VALUES
			(@queueId,@editorID,@clinicID,@location,@dictatorID)
		SELECT 1 AS Result	
	END
	ELSE
	BEGIN
		SELECT 0 AS Result
	END
END
ELSE
BEGIN
	SELECT -2 AS Result
END
END


/*
--Cambiar DictatorId AllowNulls->False, DefaultValue=''
*/
GO
