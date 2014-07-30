SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeDictatorAutoText] (
	@DictatorID  [varchar]  (50),
	@AutoText_Name  [varchar]  (100),
	@AutoText_Content  [varchar]  (1000),
	@UserName varchar(32)
) AS

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			IF NOT EXISTS(SELECT * FROM [dbo].[Dictators_AutoText] WHERE ([DictatorID] = @DictatorID AND [AutoText_Name] = @AutoText_Name))
				BEGIN
					INSERT INTO [dbo].[Dictators_AutoText] (
						[DictatorID], [AutoText_Name], [AutoText_Content] 
					) VALUES (
						@DictatorID, @AutoText_Name, @AutoText_Content 
					)

					INSERT INTO AuditLog (
						UserName, OperationName, ReferenceTag, Dictator, AuditLogType
					) VALUES (
						@UserName, 'Dictators_AutoText.Insert', @AutoText_Name, @DictatorID, 2
					)
				END
			ELSE 
			  BEGIN
					UPDATE [dbo].[Dictators_AutoText] 
					SET [AutoText_Content] = @AutoText_Content  
					WHERE ([DictatorID] = @DictatorID AND [AutoText_Name] = @AutoText_Name)

					INSERT INTO AuditLog (
						UserName, OperationName, ReferenceTag, Dictator, AuditLogType
					) VALUES (
						@UserName, 'Dictators_AutoText.Update', @AutoText_Name, @DictatorID, 2
					)
			  END

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
