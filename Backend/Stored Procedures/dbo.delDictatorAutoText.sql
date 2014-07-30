SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[delDictatorAutoText] (
	@DictatorID  [varchar]  (50),
	@AutoText_Name  [varchar]  (100),
	@UserName varchar(32)
) AS

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

					DELETE FROM [dbo].[Dictators_AutoText] 
					WHERE ([DictatorID] = @DictatorID AND [AutoText_Name] = @AutoText_Name)

					INSERT INTO AuditLog (
						UserName, OperationName, ReferenceTag, Dictator, AuditLogType
					) VALUES (
						@UserName, 'Dictators_AutoText.Delete', @AutoText_Name, @DictatorID, 1
					)

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
	RETURN
END
GO
