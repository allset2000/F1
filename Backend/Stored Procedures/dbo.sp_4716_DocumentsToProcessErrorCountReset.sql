SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author: Dustin Dorsey
-- Create date: 6/15/2015
-- Description: Temp SP used to set Failure Count in DocumentsToProcess back to 0 for all jobs that have an error count of 5 
-- =============================================

CREATE PROCEDURE [dbo].[sp_4716_DocumentsToProcessErrorCountReset] 

AS 

BEGIN
	
  UPDATE [Entrada].[dbo].[DocumentsToProcess]
  SET [ProcessFailureCount] = 0
  WHERE [ProcessFailureCount] = 5
	
END

GO
