SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 6/9/2015
-- Description: SP Used to return a list of all selected dictators a user is mapped to
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserSelectedDictators] (
	@userid int
) AS 
BEGIN

		SELECT D.* FROM PortalUserDictatorXref PUD
			INNER JOIN Dictators D on D.DictatorId = PUD.DictatorId
		WHERE PUD.UserId = @userid and PUD.IsDeleted = 0 and D.Deleted = 0

END

GO
