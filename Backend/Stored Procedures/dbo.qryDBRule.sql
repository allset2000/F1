SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[qryDBRule]  (	
	@DbRuleType [char](1),
	@ServerId [int],
	@SourceName [varchar] (64),
	@TypeId [int]
) AS
	SELECT *
	FROM DBRules
	WHERE (DbRuleType = @DbRuleType) AND 
		  (ServerId = @ServerId) AND (TargetServerId = @ServerId) AND
		  (SourceName = @SourceName) AND (TypeId = @TypeId)
RETURN

GO
