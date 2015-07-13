SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 7/9/2015
-- Description: SP used to remove actionid's from rules
-- =============================================
CREATE PROCEDURE [dbo].[sp_RemoveRulesJobActionId] (
	@ActionId INT
) AS 
BEGIN
	
	IF EXISTS(select 1 from RulesJobs where ActionId = @ActionId)
	BEGIN
		DELETE FROM RulesJobs where ActionId = @ActionId
	END
	
END

GO
