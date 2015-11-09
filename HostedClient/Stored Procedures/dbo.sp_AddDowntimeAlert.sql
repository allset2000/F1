
/****** Object:  StoredProcedure [dbo].[sp_AddDowntimeAlert]    Script Date: 8/17/2015 12:04:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Santhosh
-- Create date: 07/28/2015
-- Description: SP used to add Downtime ALerts
CREATE PROCEDURE [dbo].[sp_AddDowntimeAlert] 
(
	@Message VARCHAR(MAX),
	@StartDate DATETIME,
	@EndDate DATETIME,
	@ApplicationId INT
)
AS
BEGIN
	INSERT INTO DownTimeAlerts
	VALUES
	(@Message, @StartDate, @EndDate, @ApplicationId)
END
GO


