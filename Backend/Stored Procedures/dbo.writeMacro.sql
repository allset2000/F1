SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeMacro] (
	@DictatorID  [varchar]  (50),
	@Name  [varchar]  (100),
	@Text  [text],
	@UserName varchar(32)
) AS 
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			IF NOT EXISTS(SELECT * FROM [dbo].[Macros] WHERE ([DictatorID] = @DictatorID AND [Name] = @Name))
				BEGIN
					INSERT INTO [dbo].[Macros] (
						[DictatorID], [Name], [Text] 
					) VALUES (
						@DictatorID, @Name, @Text 
					)

					INSERT INTO AuditLog (
						UserName, OperationName, ReferenceTag, Dictator, AuditLogType
					) VALUES (
						@UserName, 'DictatorMacro.Insert', @Name, @DictatorID, 2
					)
				END
			ELSE 
			  BEGIN
					UPDATE [dbo].[Macros] 
					SET [Text] = @Text  
					WHERE ([DictatorID] = @DictatorID AND [Name] = @Name) 

					INSERT INTO AuditLog (
						UserName, OperationName, ReferenceTag, Dictator, AuditLogType
					) VALUES (
						@UserName, 'DictatorMacro.Update', @Name, @DictatorID, 2
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
