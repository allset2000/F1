SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Samuel Shoultz
-- Create date: 3/3/2015
-- Description: SP used to manage SM Favorites from mobile ws call
-- =============================================
CREATE PROCEDURE [dbo].[sp_SetSMFavorite]
	@UserId int,
	@FavoriteUserId int,
	@Maintain bit
AS 
BEGIN
	
	DECLARE @IsDeleted bit
	IF (@Maintain = 1) BEGIN SET @IsDeleted = 0 END
	ELSE BEGIN SET @IsDeleted = 1 END

	IF EXISTS (select 1 from SMContactFavorites WHERE UserId = @UserID and FavUserID = @FavoriteUserId)
	BEGIN
		UPDATE SMContactFavorites SET IsDeleted = @IsDeleted, DateUpdated = GETDATE() WHERE UserId = @UserID and FavUserID = @FavoriteUserId
	END
	ELSE
	BEGIN
		INSERT INTO SMContactFavorites(UserID, FavUserID, IsDeleted, DateCreated, DateUpdated) VALUES(@UserId, @FavoriteUserId, @IsDeleted, GETDATE(), GETDATE())
	END

END
GO
