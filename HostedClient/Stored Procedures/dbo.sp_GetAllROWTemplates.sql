
/****** Object:  StoredProcedure [dbo].[sp_GetAllROWTemplates]    Script Date: 8/17/2015 11:55:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Santhosh
-- Create date: 07/28/2015
-- Description: SP used to get all row templates
CREATE PROCEDURE [dbo].[sp_GetAllROWTemplates]
AS
BEGIN
	SELECT * FROM ROWTemplates 
	WHERE ISNULL(Deleted,0) = 0
END

GO


