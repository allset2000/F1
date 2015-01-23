SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 01/22/2015
-- Description: SP used to return a dictator entity to dictate api for validating userid / dictatorid
-- =============================================
CREATE PROCEDURE [dbo].[sp_ValidateUserDictatorMapping]
(
	@UserId INT,
	@DictatorId INT,
	@SessionToken varchar(100)
)
AS
BEGIN

	SELECT * FROM Dictators WHERE DictatorId = @DictatorId and UserId = @UserId

	UPDATE UserSessionTracking SET LastActivity = GETDATE() WHERE UserId = @UserId and SessionToken = @SessionToken

END


GO
