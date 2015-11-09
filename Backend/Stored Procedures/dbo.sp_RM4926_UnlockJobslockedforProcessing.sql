SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Dustin Dorsey
-- Create date: 7/10/2015
-- Description: Temp SP used to set IsLockedForProcessing back to 0 for jobs
-- =============================================
CREATE PROCEDURE [dbo].[sp_RM4926_UnlockJobslockedforProcessing] 
@Jobnumber varchar(20)
AS
BEGIN
        
  UPDATE [Entrada].[dbo].[Jobs]
  SET IsLockedForProcessing = 0
  WHERE [jobnumber] = @Jobnumber
        
END
GO
