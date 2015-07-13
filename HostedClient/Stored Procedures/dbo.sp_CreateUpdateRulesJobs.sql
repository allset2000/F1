SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 7/9/2015
-- Description: SP used to Create/Update RuesJob data
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateUpdateRulesJobs] (
	@RuleId INT,
	@ProviderId INT,
	@QueueId INT,
	@ActionId INT
) AS 
BEGIN
	
	IF NOT EXISTS(select 1 from RulesJobs where RuleId = @RuleId and ActionId = @ActionId)
	BEGIN
		INSERT INTO RulesJobs(RuleID, QueueID, ProviderID) VALUES(@RuleId, @QueueId, @ProviderId)
	END
	ELSE
	BEGIN
		UPDATE RulesJobs SET ProviderId = @ProviderId, QueueId = @QueueId where RuleId = @RuleId and ActionId = @ActionId
	END
	
END

GO
