/****** Object:  StoredProcedure [dbo].[sp_RemoveJ2D]    Script Date: 8/19/2015 3:57:34 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Santhosh
-- Create date: 07/03/2015
-- Description: SP used to delete Backend J2D Error

CREATE PROCEDURE [dbo].[sp_RemoveJ2D]
(
	@JobNumber VARCHAR(20)
)
AS
BEGIN
	DELETE FROM JobsToDeliver WHERE JobNumber = @JobNumber	
END
GO


