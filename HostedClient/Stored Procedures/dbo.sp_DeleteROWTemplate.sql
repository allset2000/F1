/****** Object:  StoredProcedure [dbo].[sp_DeleteROWTemplate]    Script Date: 8/17/2015 11:39:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Santhosh
-- Create date: 07/28/2015
-- Description: SP used to delete row template
CREATE PROCEDURE [dbo].[sp_DeleteROWTemplate] 
(
	@ROWTemplateId INT
)
AS
BEGIN
	UPDATE ROWTemplates 
	SET Deleted = 1
	WHERE ROWTemplateId = @ROWTemplateId		
END

GO


