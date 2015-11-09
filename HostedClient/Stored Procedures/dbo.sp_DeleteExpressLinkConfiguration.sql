
/****** Object:  StoredProcedure [dbo].[sp_DeleteExpressLinkConfiguration]    Script Date: 8/17/2015 12:00:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Santhosh
-- Create date: 07/02/2015
-- Description: SP used to delete Express Link Configuration

CREATE PROCEDURE [dbo].[sp_DeleteExpressLinkConfiguration]
(
	@ID INT = -1
)
AS
BEGIN
	UPDATE ExpressLinkConfigurations 
	SET Deleted = 1
		, Enabled = 0
	WHERE ID = @ID
	SELECT 1
END


GO


