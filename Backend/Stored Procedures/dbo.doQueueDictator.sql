SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Juan C. Ruvalcaba
-- =============================================
CREATE PROCEDURE [dbo].[doQueueDictator]
	@queueId smallint, 
	@clinicID smallint, 
	@location smallint, 
	@dictatorID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @tempQueueIdClinic int, @tempQueueIdDictator int
DECLARE @tempQueueIdClinicPrevious int, @tempQueueIdDictatorPrevious int

SELECT @tempQueueIdClinic = Queue_ID FROM Queue_Dictators WHERE Queue_ID = @queueId AND ClinicID = @clinicID
SELECT @tempQueueIdDictator = Queue_ID FROM Queue_Dictators WHERE Queue_ID = @queueId AND DictatorID = @dictatorID

--SELECT @tempQueueIdClinicPrevious = Queue_ID FROM Queue_Dictators WHERE Queue_ID <> @queueId AND ClinicID = @clinicID
--SELECT @tempQueueIdDictator = Queue_ID FROM Queue_Dictators WHERE Queue_ID <> @queueId AND DictatorID = @dictatorID

IF @queueId > 0
BEGIN
	IF @tempQueueIdClinic IS NULL OR @tempQueueIdDictator IS NULL
	BEGIN
		/*IF @tempQueueIdClinicPrevious IS NULL AND @tempQueueIdDictatorPrevious IS NULL
		BEGIN*/
			INSERT INTO Queue_Dictators
				(Queue_ID, ClinicID, Location, DictatorID)
			VALUES
				(@queueId,@clinicID,@location,@dictatorID)
			SELECT 1 AS Result
		/*END
		ELSE
		BEGIN
			SELECT -1 AS Result
		END*/
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
