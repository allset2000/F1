SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[writeJ2D] (
	@JobNumber  [varchar]  (20),
	@Method  [smallint],
	@LastUpdatedOn  [datetime]
) AS 
UPDATE [dbo].[JobsToDeliver]
	SET [Method] = @Method,
	[LastUpdatedOn] = @LastUpdatedOn
WHERE [JobNumber] = @JobNumber


GO

