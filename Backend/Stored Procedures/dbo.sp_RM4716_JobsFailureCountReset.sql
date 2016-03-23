
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Dustin Dorsey
-- Create date: 6/15/2015
-- Description: Temp SP used to set Failure Count in Jobs back to 0 for a specific jobnumber
-- =============================================
CREATE PROCEDURE [dbo].[sp_RM4716_JobsFailureCountReset] 
@Jobnumber varchar(20)
AS
BEGIN
        
  UPDATE [dbo].[Jobs]
  SET [ProcessFailureCount] = 0
  WHERE [jobnumber] = @Jobnumber
        
END
GO

