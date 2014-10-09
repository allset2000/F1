SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Sam Shoultz
-- Create date: 10/7/2014
-- Description: SP called from DictateAPI to pull Jobs to sync on mobile
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetJobsToSync] (
	 @DictatorId int,
	 @MaxFutureDays int
) AS 
BEGIN
	IF (@MaxFutureDays >= 0)
	BEGIN
		SELECT J.* 
		FROM Dictations D
			INNER JOIN Jobs J ON D.JobID = J.JobID 
			INNER JOIN Encounters E ON J.EncounterID = E.EncounterID
			INNER JOIN Queue_Users QU on QU.QueueID = D.QueueID
			INNER JOIN Queues Q on Q.QueueID = QU.QueueID
		WHERE D.Status in (100,200)
				AND DATEDIFF (D, GETDATE (), E.AppointmentDate) <= @MaxFutureDays
				AND Q.Deleted = 0
				AND (D.DictatorID = @DictatorId or QU.DictatorID = @DictatorId)
	END
	ELSE
	BEGIN
		SELECT J.* 
		FROM Dictations D
			INNER JOIN Jobs J ON D.JobID = J.JobID 
			INNER JOIN Queue_Users QU on QU.QueueID = D.QueueID
			INNER JOIN Queues Q on Q.QueueID = QU.QueueID
		WHERE D.Status in (100,200)
				AND Q.Deleted = 0
				AND (D.DictatorID = @DictatorId or QU.DictatorID = @DictatorId)
	END
END
GO
