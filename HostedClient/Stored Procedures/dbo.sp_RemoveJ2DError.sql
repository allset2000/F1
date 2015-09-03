
/****** Object:  StoredProcedure [dbo].[sp_RemoveJ2DError]    Script Date: 8/17/2015 12:11:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Santhosh
-- Create date: 07/03/2015
-- Description: SP used to delete Hosted J2D Error

CREATE PROCEDURE [dbo].[sp_RemoveJ2DError]
(
	@JobId INT = -1
)
AS
BEGIN
	Delete FROM JobsDeliveryErrors WHERE JobId=@JobId
	SELECT 1
END
GO


