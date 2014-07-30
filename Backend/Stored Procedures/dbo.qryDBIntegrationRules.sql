SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[qryDBIntegrationRules] 
(
	@ServerId [int]
) AS
	SELECT *
	FROM DBRules
	WHERE (ServerId = @ServerId) AND (TargetServerId <> @ServerId)
	ORDER BY DbRuleType, SourceName, DbRuleIndex, TargetServerId
RETURN

GO
