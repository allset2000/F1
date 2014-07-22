SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteUser]
	-- Add the parameters for the stored procedure here
	@UserName varchar(20)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM aspnet_Users WHERE LoweredUserName=LOWER(@UserName))
			BEGIN
				DECLARE @UserId varchar(100);
				SELECT @UserId = UserId FROM aspnet_Users WHERE LoweredUserName=LOWER(@UserName);
				BEGIN TRANSACTION
					DELETE FROM aspnet_Membership Where UserId=@UserId
					DELETE FROM aspnet_UsersInRoles Where UserId=@UserId
					DELETE FROM aspnet_Users Where UserId=@UserId
					INSERT INTO UsersDeleted VALUES(@UserName, SUSER_NAME(), GETDATE())
				COMMIT TRANSACTION
			END
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
