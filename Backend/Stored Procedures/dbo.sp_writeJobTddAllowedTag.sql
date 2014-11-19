SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 11/7/2014
-- Description: SP used to insert / edit JobsTddallowedtags - used in Admin Console
-- =============================================
CREATE PROCEDURE [dbo].[sp_writeJobTddAllowedTag](
	@ID int,
	@SplitRuleId int,
	@Name varchar(50),
	@Required bit,
	@FieldName varchar(1000)
)  AS 
BEGIN

	IF NOT EXISTS(SELECT * FROM JobsTddAllowedTags WHERE ID = @ID)
	BEGIN
		INSERT INTO JobsTddAllowedTags(SplitRuleID,Name,Required,FieldName) values(@SplitRuleId,@Name,@Required,@FieldName)
	END
	ELSE
	BEGIN
		UPDATE JobsTddAllowedTags SET Name = @Name, Required = @Required, FieldName = @FieldName where ID = @ID
	END	

	SELECT ID FROM JobsTddAllowedTags where SplitRuleID = @SplitRuleId and Name = @Name and FieldName = @FieldName

END


GO
