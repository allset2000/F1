/****** Object:  StoredProcedure [dbo].[sp_GetROWTemplate]    Script Date: 8/28/2015 8:52:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Santhosh
-- Create date: 07/28/2015
-- Description: SP used to get row template
CREATE PROCEDURE [dbo].[sp_GetROWTemplate]
(
	@ROWTemplateId INT
)
AS
BEGIN
	SELECT * FROM ROWTemplates 
	WHERE ROWTemplateId = @ROWTemplateId
		AND ISNULL(Deleted,0) = 0
END

GO


