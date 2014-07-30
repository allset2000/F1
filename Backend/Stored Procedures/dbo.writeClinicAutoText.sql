SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeClinicAutoText] (
	@ClinicID  [smallint],
	@AutoText_Name  [varchar]  (100),
	@AutoText_Content  [varchar]  (255),
	@UserName varchar(32)
) AS

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			IF NOT EXISTS(SELECT * FROM [dbo].[ClinicsAutoText] WHERE ([ClinicID] = @ClinicID AND [AutoText_Name] = @AutoText_Name))
				BEGIN
					INSERT INTO [dbo].[ClinicsAutoText] (
						[ClinicID], [AutoText_Name], [AutoText_Content] 
					) VALUES (
						@ClinicID, @AutoText_Name, @AutoText_Content 
					)

					INSERT INTO AuditLog (
						UserName, OperationName, ReferenceTag, Dictator, AuditLogType
					) VALUES (
						@UserName, 'ClinicsAutoText.Insert', @AutoText_Name, @ClinicID, 2
					)
				END
			ELSE 
				BEGIN
					UPDATE [dbo].[ClinicsAutoText] 
					SET [AutoText_Content] = @AutoText_Content  
					WHERE ([ClinicID] = @ClinicID AND [AutoText_Name] = @AutoText_Name)

					INSERT INTO AuditLog (
						UserName, OperationName, ReferenceTag, Dictator, AuditLogType
					) VALUES (
						@UserName, 'ClinicsAutoText.Update', @AutoText_Name, @ClinicID, 2
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
