
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 01/22/2015
-- Description: SP used to return a list of users tied to a list of dictators
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserMappping]
(
	@DictatorIdString varchar(100)
)
AS
BEGIN

	CREATE TABLE #tmp_dictids
	(
		DictatorId INT
	)

	INSERT INTO #tmp_dictids
	SELECT * FROM split (@DictatorIdString, ',')

	SELECT U.UserId,U.UserName,D.DictatorId,U.PWResetRequired FROM Dictators D
		INNER JOIN Users U on U.UserId = D.UserId
	WHERE DictatorId in (SELECT DictatorId from #tmp_dictids)

	DROP TABLE #tmp_dictids

END


GO
