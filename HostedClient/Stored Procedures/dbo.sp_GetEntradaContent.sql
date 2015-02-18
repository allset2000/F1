SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Mikayil Bayramov
-- Create date: 2/9/2015
-- Description: SP used to pull the Entrada Content. If ContentKey is not provided, then all active contents will be returned.
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetEntradaContent]
	@ContentKey AS VARCHAR(50) = NULL
AS 
BEGIN
	SELECT ContentID, ContentKey, [Description], VersionNumber, Content
	FROM dbo.EntradaContent
	WHERE ContentKey LIKE COALESCE(@ContentKey,'%') AND IsActive = 1
END
GO
