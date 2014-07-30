SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[setUserPasswordWithToken] (
	@ContactId int,
	@UserID  varchar (48),
    @EMail  varchar (48),
	@SecurityToken  varchar(255),
	@NewPassword varchar (48),
	@UserSettings varchar(4096)
) AS 

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		
		 UPDATE [dbo].[Contacts]
		   SET
		    [Password] = @NewPassword,
		    [ASPMembershipPwd] = @NewPassword, 
		    [UserSettings] = @UserSettings,
		    [SecurityToken] = ''
		  WHERE ([ContactId] = @ContactId) AND (UserID = @UserID) AND (EMail = @EMail) AND (SecurityToken = @SecurityToken)

		  IF EXISTS(SELECT * FROM [dbo].[Contacts]
				    WHERE ((ContactType = 'E') AND [ContactId] = @ContactId) AND (UserID = @UserID))
		  BEGIN
			UPDATE  [dbo].[Editors] 
			SET EditorPwd = @NewPassword 
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
