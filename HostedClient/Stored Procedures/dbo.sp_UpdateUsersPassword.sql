SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 01/21/2015
-- Description: SP used to Update the User account and reset the password
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateUsersPassword]
(
	@UserId int,
	@Salt varchar(32),
	@Password varchar(64)
)
AS
BEGIN
	UPDATE Users SET Password = @Password, Salt = @Salt WHERE UserId = @UserId

	SELECT * FROM Users where UserId = @UserId
END
GO
