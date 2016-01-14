SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Narender 
-- Create date: 14 Jan 2016
-- Description: This proc returns Queues for selected clinic
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetQueueDictators] (
	@clinicId int
) AS
BEGIN
	SELECT * from Queues where ClinicId = @clinicId order by Name ASC
END
