SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_Reporting_Promantra_Job_List]

	@ReceivedOn datetime,
	@ReceivedOn2 datetime,
	@PayTypeVar varchar(20), --- This is actually the ClinicCode
	@type varchar(10) 

AS
BEGIN

SELECT Jobs.JobNumber, JobType, DictatorID, ReceivedOn FROM Entrada.dbo.Jobs INNER JOIN Entrada.dbo.JobStatusA ON Jobs.JobNumber=JobStatusA.JobNumber
WHERE Status=140 AND
(
ClinicID IN
(
SELECT DISTINCT ClinicID FROM
(
SELECT * FROM Entrada.dbo.Queue_Dictators WHERE Queue_ID IN
(
SELECT DISTINCT QueueID FROM Entrada.dbo.Queue_Editors WHERE EditorID IN
(
SELECT Editors.EditorID FROM Entrada.dbo.Editors INNER JOIN Entrada.dbo.Editors_Pay ON Editors.EditorID=Editors_Pay.EditorID WHERE PayType='PRO' AND Type=@type
)
)
) A
WHERE ClinicID<>0
)

OR

DictatorID IN
(
SELECT DictatorID FROM
(
SELECT * FROM Entrada.dbo.Queue_Dictators WHERE Queue_ID IN
(
SELECT DISTINCT QueueID FROM Entrada.dbo.Queue_Editors WHERE EditorID IN
(
SELECT Editors.EditorID FROM Entrada.dbo.Editors INNER JOIN Entrada.dbo.Editors_Pay ON Editors.EditorID=Editors_Pay.EditorID WHERE PayType='PRO' AND Type=@type
)
)
) A
WHERE DictatorID<>''
)
)
ORDER BY ReceivedOn


END
GO
