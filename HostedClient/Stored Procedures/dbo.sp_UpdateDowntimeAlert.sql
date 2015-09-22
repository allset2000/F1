/****** Object:  StoredProcedure [dbo].[sp_AddDowntimeAlert]    Script Date: 9/22/2015 8:16:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Santhosh
-- Create date: 09/22/2015
-- Description: SP used to update Downtime ALerts
CREATE PROCEDURE [dbo].[sp_UpdateDowntimeAlert] 
(
	@DowntimeAlertId INT,
	@Message VARCHAR(MAX),
	@StartDate DATETIME,
	@EndDate DATETIME,
	@ApplicationId INT
)
AS
BEGIN
	Update DownTimeAlerts
	SET
		Message = @Message,		
		StartDate = @StartDate, 
		EndDate = @EndDate, 
		ApplicationId = @ApplicationId
	WHERE DowntimeAlertId = @DowntimeAlertId
END
GO


