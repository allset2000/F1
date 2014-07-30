SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_DuplicateEditingQueue]
	@QueueOldId int,
	@QueueNewId int,
	@QueueNewType int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO Queue_Names(QueueID, QueueName, Type) SELECT @QueueNewId, QueueName, @QueueNewType FROM Queue_Names WHERE QueueID=@QueueOldId
			INSERT INTO Queue_Dictators(Queue_ID, ClinicID, Location, DictatorID) SELECT @QueueNewId AS Queue_ID, ClinicID, Location, DictatorID FROM Queue_Dictators WHERE Queue_ID=@QueueOldId
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
		   BEGIN
			ROLLBACK TRANSACTION
							DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
							SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
			RAISERROR(@ErrMsg, @ErrSeverity, 1)
		   END
	END CATCH
END
GO
