
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Raghu A>
-- Create date: <4/6/2015>
-- Description:	<get macro details by dictatorID>
-- =============================================
-- Exec spv_GetMacrosByDictatorID 2008
CREATE PROCEDURE [dbo].[spv_GetMacrosByDictatorID] 
	@DictatorID INT,
	@UserId Int
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

    SELECT EM.Name As MacroName,Em.[Text] As MacroValue  
	FROM dbo.Dictators D WITH(NOLOCK)
		INNER JOIN dbo.Clinics C WITH(NOLOCK) on D.ClinicID=C.ClinicID
		INNER JOIN dbo.EN_Macros EM WITH(NOLOCK) on EM.DictatorID=(C.ClinicCode+D.DictatorName)
	WHERE D.DictatorID=@DictatorID

END

GO
