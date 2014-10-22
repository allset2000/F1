USE [Entrada_Copy]
GO

/****** Object:  StoredProcedure [dbo].[spv_UpgradeScript_post_SP4]    Script Date: 10/22/2014 2:18:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spv_UpgradeScript_post_SP4]
AS
BEGIN
--For Non-Generic Jobs
UPDATE J
SET J.ISGENERICJOB = 0, J.ISNEWSCHEMA = 1
FROM jobs J INNER JOIN jobs_client JC on j.jobnumber = jc.jobnumber
INNER JOIN [EntradaHostedClient].dbo.Jobs HDB on jc.filename = HDB.jobnumber
INNER JOIN [EntradaHostedClient].dbo.Encounters HE on HDB.EncounterID = HE.encounterID and HE.ScheduleID is not null

--For Generic Jobs
UPDATE J
SET J.ISGENERICJOB = 1, J.ISNEWSCHEMA = 1
FROM jobs J INNER JOIN jobs_client JC on j.jobnumber = jc.jobnumber
INNER JOIN [EntradaHostedClient].dbo.Jobs HDB on jc.filename = HDB.jobnumber
INNER JOIN [EntradaHostedClient].dbo.Encounters HE on HDB.EncounterID = HE.encounterID and HE.ScheduleID is null

END


GO
