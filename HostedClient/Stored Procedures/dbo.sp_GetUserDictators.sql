SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/16/2015
-- Description: SP used to gather the dictators attched to a specifc user
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUserDictators] (
	 @UserId int
) AS 
BEGIN

	SELECT UserId, DictatorName, DictatorId, DefaultJobTypeId, DefaultQueueId, C.ClinicCode, C.Name as 'ClinicName'
	FROM Dictators D
		INNER JOIN Clinics C on C.ClinicId = D.ClinicId
	WHERE UserId = @UserId

END




GO
