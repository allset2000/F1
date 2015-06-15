SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Narender
-- Create date: 06/10/2015
-- Description: SP Used to update the JobProcessFailureCount in DocumentsToProcess table
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateDocToProcessJobProcessFailureCount]
 @jobNumber VARCHAR(20)
 AS
BEGIN
  UPDATE DocumentsToProcess SET ProcessFailureCount = ISNULL(ProcessFailureCount,0)+1 WHERE (JobNumber = @jobNumber)
END

GO


