SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[apdJobToDeliver] (
	@JobNumber  [varchar]  (20),
	@Method  [smallint],
	@RuleName  [varchar]  (100),
	@LastUpdatedOn  [datetime] 
) AS

	IF (LEN(@RuleName) = 0)
	BEGIN
      SET @RuleName = NULL
    END
	    
	IF NOT EXISTS(SELECT * FROM [dbo].[JobsToDeliver] WHERE (([JobNumber] = @JobNumber) AND ([Method] = @Method) AND ([RuleName] = @RuleName)))
	   BEGIN
		INSERT INTO [dbo].[JobsToDeliver] (
			[JobNumber],[Method], [RuleName], [LastUpdatedOn] 
		) VALUES  (
			@JobNumber, @Method, @RuleName, @LastUpdatedOn
		)
	   END
GO
