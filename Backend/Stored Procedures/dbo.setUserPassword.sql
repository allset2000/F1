SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[setUserPassword] (
	@ContactId int,
	@UserID  varchar (48),
	@Password  varchar(48),
	@UserSettings varchar(4096)
) AS 

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
				
		UPDATE [dbo].[Contacts] 
		 SET
			 [Password] = @Password ,
			 [UserSettings] = @UserSettings,
			 [SecurityToken] = ''
		WHERE 
			([ContactId] = @ContactId)
			
		  IF EXISTS(SELECT * FROM [dbo].[Contacts] 
					WHERE ((ContactType = 'E') AND [ContactId] = @ContactId) AND (UserID = @UserID))
		  BEGIN
			UPDATE  [dbo].[Editors] 
			SET EditorPwd = @Password 
			WHERE (EditorIdOk = @ContactId) AND (EditorID = @UserID)
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
