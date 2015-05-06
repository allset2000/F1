SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author: Sam Shoultz
-- Create date: 5/6/2015
-- Description: SP used to Create / Update User Device tracking records
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateUpdateDeviceTracking] (
	@UserId int,
	@DeviceId varchar(50),
	@DeviceInfo varchar(1000)
) AS 
BEGIN

	IF NOT EXISTS(SELECT * FROM UserDeviceTracking where UserId = @UserId and DeviceId = @DeviceId)
	BEGIN
		INSERT INTO UserDeviceTracking(UserId,DeviceId,DeviceInfo,ChangedOn)
		VALUES(@UserId, @DeviceId, @DeviceInfo, GETDATE())

	END
	ELSE
	BEGIN
		UPDATE UserDeviceTracking SET DeviceInfo = @DeviceInfo, ChangedOn=GETDATE() where UserId = @UserId and DeviceId = @DeviceId
	END

END




GO
