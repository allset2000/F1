SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author: Dustin Dorsey
-- Create date: 7/13/2015
-- Description: Temp SP used to reset Failure Count in HostedClient Jobs back to 0 for a specific jobid
-- =============================================
CREATE PROCEDURE [dbo].[sp_RM4901_JobsFailureCountReset] 
@JobID bigint
AS
BEGIN
        
  UPDATE [EntradaHostedClient].[dbo].[Jobs]
  SET [ProcessFailureCount] = 0
  WHERE [jobid] = @JobID
        
END
GO
