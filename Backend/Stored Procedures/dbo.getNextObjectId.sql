SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[getNextObjectId] (
   @SourceName varchar(64)
) AS

DECLARE @CurrentIdValue int

UPDATE DbRules
SET @CurrentIdValue = CurrentIdValue = CurrentIdValue + 1
WHERE (SourceName = @SourceName) AND (DbRuleType = 'I')

IF (@CurrentIdValue < 10)
BEGIN

	DECLARE @sql varchar(1000)
	DECLARE @IdTableName varchar(64)
	DECLARE @IdFieldName varchar(64)
	
	SELECT @IdTableName = SourceName, @IdFieldName = IdFieldName
	FROM DbRules
	WHERE (SourceName = @SourceName) AND (DbRuleType = 'I')
	
	SET @sql = 'UPDATE DBRules ' +
               'SET CurrentIdValue = (SELECT MAX(' + @IdFieldName + ') FROM ' + @IdTableName + ') ' + 
               'WHERE (SourceName = ''' + @SourceName + ''') AND (DbRuleType = ''I'')'

    EXEC (@sql)
	
	UPDATE DbRules
	SET @CurrentIdValue = CurrentIdValue = CurrentIdValue + 1
	WHERE (SourceName = @SourceName) AND (DbRuleType = 'I')

END

SELECT @CurrentIdValue
		 
RETURN
GO
