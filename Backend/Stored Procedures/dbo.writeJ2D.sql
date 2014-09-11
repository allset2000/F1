SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[writeJ2D] (
	@JobNumber  [varchar]  (20)
) AS 
BEGIN
	Delete from  [dbo].[JobsToDeliver] WHERE [JobNumber] = @JobNumber
END

GO

