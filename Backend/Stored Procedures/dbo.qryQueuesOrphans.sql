SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryQueuesOrphans] (
	@OrphanType varchar(24)
)
AS

  IF (@OrphanType = 'Clinics')
  BEGIN
  
    SELECT * FROM Clinics
    WHERE ClinicID NOT IN (SELECT ClinicID 
						   FROM QueueMembers 
						   WHERE (ClinicID <> -1 AND QueueMemberStatus = 'A')) AND ClinicID > 0
	ORDER BY ClinicName
	
  RETURN
  END

  IF (@OrphanType = 'Dictators')
  BEGIN
  
    SELECT * FROM Dictators
    WHERE DictatorIdOk NOT IN (SELECT DictatorId
							   FROM QueueMembers
							   WHERE (DictatorId <> -1 AND QueueMemberStatus = 'A')) AND
		  ClinicID NOT IN (SELECT ClinicId
					       FROM QueueMembers
						   WHERE (ClinicId <> -1 AND QueueMemberStatus = 'A'))
	ORDER BY DictatorID

  RETURN
  END

  IF (@OrphanType = 'Editors')
  BEGIN
  
    SELECT * FROM vwEditors
    WHERE EditorIdOk NOT IN (SELECT EditorIdOk
							 FROM vwQueueModel
							 WHERE (EditorIdOk <> -1 AND EditorStatus = 'A')) AND EditorStatus = 'A'
	ORDER BY EditorID
	 
  RETURN
  END
  
RETURN
GO
