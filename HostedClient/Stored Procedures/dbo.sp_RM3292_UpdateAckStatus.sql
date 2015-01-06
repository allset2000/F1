SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author: Dustin Dorsey
-- Create date: 1/5/15
-- Description: Temp SP used mass update Ack Status on Jobs_Row
-- =============================================

CREATE PROCEDURE [dbo].[sp_RM3292_UpdateAckStatus] 
(
@AckStatus int,
@JobID varchar(MAX)
) 

AS 

BEGIN
	
UPDATE Jobs_ROW
SET AckStatus = @AckStatus
WHERE jobid IN (SELECT [Value] FROM dbo.split(@JobID, ','))
		
END


GO
