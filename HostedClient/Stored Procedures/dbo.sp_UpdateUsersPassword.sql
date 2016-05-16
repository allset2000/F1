
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 01/21/2015
-- Description: SP used to Update the User account and reset the password
--Modified : Raghu A -- 05/16/2016 -- updated in Password history table 
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateUsersPassword]
(
	@UserId int,
	@Salt varchar(32),
	@Password varchar(64)
)
AS
BEGIN

  SET NOCOUNT ON;  

	BEGIN TRY 
		BEGIN TRANSACTION 
			UPDATE dbo.Users SET Password = @Password, Salt = @Salt,LastPasswordReset=NULL,SecurityToken='',IsLockedOut=0 WHERE UserId = @UserId
	
			INSERT INTO [UserPasswordHistory] 
				  (UserId,Password,Salt,IsActive,DateCreated)
			VALUEs
				  (@UserId,@Password,@Salt,1,GETDATE())

			SELECT * FROM Users where UserId = @UserId
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
