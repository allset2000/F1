SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_JobsToJobsDB2]
AS 
SELECT s.ehrencounterid, e.encounterid, e.scheduleid, ehcj.jobnumber
FROM 
EntradaHostedClient.dbo.jobs ehcj			
inner join EntradaHostedClient.dbo.encounters e	on e.encounterid=ehcj.encounterid
inner join EntradaHostedClient.dbo.schedules s	on s.scheduleid=e.scheduleid
GO
