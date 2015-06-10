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
 declare @ProcessFailureCount smallint

 IF(( select ProcessFailureCount from DocumentsToProcess where JobNumber = @jobNumber) is NOT NULL)
			UPDATE DocumentsToProcess SET @ProcessFailureCount = ProcessFailureCount = ProcessFailureCount + 1 WHERE (JobNumber = @jobNumber)
 ELSE
		UPDATE DocumentsToProcess SET  ProcessFailureCount = 1 WHERE (JobNumber = @jobNumber)
END

GO


