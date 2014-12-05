SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 12/4/2014
-- Description: SP called from AdminConsole to display all providers mapped to a rule
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetRuleViewOnly] (
	 @RuleId smallint,
	 @ViewType varchar(100)
) AS 
BEGIN
	IF(@ViewType = 'Provider')
	BEGIN
		SELECT rj.ruleid,rj.actionid,rj.dictatorid,rj.queueid,rj.providerid,rj.ruleid,q.name as 'QueueName',p.Description as 'ProviderName',p.EHRCode as 'EHRCode'
		FROM rulesJobs rj
			INNER JOIN Rules r on r.RuleID = rj.RuleID
			INNER JOIN Queues q on q.QueueID = rj.QueueID
			LEFT OUTER JOIN RulesProviders p on p.ID = rj.ProviderID
		where r.RuleID = @RuleId
	END
	ELSE IF(@ViewType = 'Locations')
	BEGIN
		SELECT rl.ID, rl.ClinicID, rl.EHRCode, rl.Description
		FROM RulesLocations rl
			INNER JOIN RulesLocationsXref rlx on rlx.LocationID = rl.ID
			INNER JOIN Rules r on r.RuleID = rlx.RuleID
		WHERE r.RuleID = @RuleId
	END
	ELSE IF(@ViewType = 'Reasons')
	BEGIN
		SELECT rr.ID, rr.ClinicID, rr.EHRCode, rr.Description, rr.Type
		FROM RulesReasons rr
			INNER JOIN RulesReasonsXref rrx on rrx.ReasonID = rr.ID
			INNER JOIN Rules r on r.RuleID = rrx.RuleID
		WHERE r.RuleID = @RuleId
	END
END
GO
