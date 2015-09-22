USE [EntradaHostedClient]
GO

/****** Object:  StoredProcedure [dbo].[sp_AddDowntimeAlert]    Script Date: 9/22/2015 8:16:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Santhosh
-- Create date: 09/22/2015
-- Description: SP used to delete Downtime ALerts
CREATE PROCEDURE [dbo].[sp_DeleteDowntimeAlert] 
(
	@DowntimeAlertId INT	
)
AS
BEGIN
	DELETE FROM DownTimeAlerts WHERE DowntimeAlertId = @DowntimeAlertId
END
GO


