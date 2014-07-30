SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[delMacro] (
	@DictatorID  [varchar]  (50),
	@Name  [varchar]  (100),
	@UserName varchar(32)
) AS 
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			DELETE FROM [dbo].[Macros] 
			WHERE ([DictatorID] = @DictatorID AND [Name] = @Name) 

			INSERT INTO AuditLog (
				UserName, OperationName, ReferenceTag, Dictator, AuditLogType
			) VALUES (
				@UserName, 'DictatorMacro.Delete', @Name, @DictatorID, 1
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
