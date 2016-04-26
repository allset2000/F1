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
	@DictatorID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT EM.Name As MacroName,Em.[Text] As MacroValue  
	FROM Dictators D WITH(NOLOCK)
		INNER JOIN Clinics C WITH(NOLOCK) on D.ClinicID=C.ClinicID
		INNER JOIN EN_Macros EM WITH(NOLOCK) on EM.DictatorID=(C.ClinicCode+D.DictatorName)
	WHERE D.DictatorID=@DictatorID


END
GO
