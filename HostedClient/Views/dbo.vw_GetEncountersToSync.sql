SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Mikayil Bayramov
-- Create date: 12/10/2014
-- Description: View called from sp_GetEncountersToSync to pull encounters to sync
-- =============================================
CREATE VIEW [dbo].[vw_GetEncountersToSync]
AS
	SELECT e.*, d.DictatorID AS Dictations_DictatorID, qu.DictatorID AS Queue_Users_DictatorID
	FROM Dictations AS d INNER JOIN Jobs AS j ON d.JobID = j.JobID
			             INNER JOIN Encounters AS e ON j.EncounterID = e.EncounterID
			             INNER JOIN Queue_Users AS qu ON qu.QueueID = d.QueueID
			             INNER JOIN Queues AS q ON q.QueueID = qu.QueueID
	WHERE d.[Status] IN (200,100) AND 
	      q.Deleted = 0

GO
