SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Sam Shoultz
-- Create date: 12/3/2014
-- Description: SP called from DictateAPI to pull Dictations to sync on mobile
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetDictationsToSync] (
	 @DictatorId int,
	 @MaxFutureDays int
) AS 
BEGIN
	IF (@MaxFutureDays > 0)
	BEGIN	 
		SELECT D.* 
		FROM Dictations D
			INNER JOIN Jobs J ON D.JobID = J.JobID
			INNER JOIN Encounters E ON J.EncounterID = E.EncounterID
			INNER JOIN Queue_Users QU on QU.QueueID = D.QueueID
			INNER JOIN Queues Q on Q.QueueID = QU.QueueID
		WHERE (D.DictatorID = @DictatorId or QU.DictatorID = @DictatorId)
			  AND D.Status in (200,100)
			  AND DATEDIFF (D, GETDATE (), E.AppointmentDate) <= @MaxFutureDays
			  AND Q.Deleted = 0
	END
	ELSE
	BEGIN
		SELECT D.* 
		FROM Dictations D
			INNER JOIN Jobs J ON D.JobID = J.JobID
			INNER JOIN Queue_Users QU on QU.QueueID = D.QueueID
			INNER JOIN Queues Q on Q.QueueID = QU.QueueID
		WHERE D.Status in (200,100)
			  AND (D.DictatorID = @DictatorId or QU.DictatorID = @DictatorId)
			  AND Q.Deleted = 0
	END
END
GO
