SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 7/24/2015
-- Description: SP called from Expresslink to get the ROWTempalte record
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetRowTemplateById] (
	 @TemplateId int
) AS 
BEGIN
	SELECT ROWTemplateId,
		   Description,
		   Template,
		   SplitMessageByTags
	FROM ROWTemplates
	WHERE ROWTemplateID = @TemplateId
END
GO
