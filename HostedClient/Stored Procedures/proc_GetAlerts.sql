USE [EntradaHostedClient]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetAlerts]    Script Date: 8/17/2015 11:17:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 1/14/2015
-- Description: SP used to pull the User Entity (object) from the DB

--Created by:Entrada dev
--Creation Date:06/12/2015
-- =============================================
CREATE  PROCEDURE [dbo].[proc_GetAlerts] 

@ApplicationId int
	

AS 
BEGIN

SELECT   DowntimeAlertId, Message, Cast(StartDate as datetime) startdate, Cast(EndDate as datetime) enddate
FROM         DowntimeAlerts where Enddate= (Select max(enddate) from DowntimeAlerts) and ApplicationId= @ApplicationId



END