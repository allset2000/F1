SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Raghu A
-- Create date: 5/11/2016
-- Description:	Update dictate Preferences
-- =============================================
CREATE PROCEDURE [dbo].[spv_UpdateDictatorSettings]
	@DictatorID Int,
	@UserID Int,
	@Preference Varchar(Max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF NOT EXISTS(SELECT '*' FROM dbo.Dictators WITH(NOLOCK) WHERE DictatorID=@DictatorID AND UserID=@UserId)
	 BEGIN
	   RAISERROR (N'Dictator not mapped to authenticated user.', 16, 1);
	   RETURN
     END

    -- Insert statements for procedure here
	UPDATE dbo.Dictators SET Preference = @Preference WHERE DictatorID =@DictatorID
END
GO
