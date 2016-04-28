SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XX  Entrada Inc
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
--X PROCEDURE: [spv_Update_RhythmJobStatus]
--X
--X AUTHOR: Naga
--X
--X DESCRIPTION: Stored procedure to update the job status for Rhythm jobs
--X				 
--X
--X ASSUMPTIONS: 
--X
--X DEPENDENTS: 
--X
--X PARAMETERS: 
--X
--X RETURNS:  
--X
--X TABLES REQUIRED: 
--X
--X HISTORY:
--X_____________________________________________________________________________
--X  VER   |    DATE      |  BY						|  COMMENTS - include Ticket#
--X_____________________________________________________________________________
--X   0    | 04/27/2016   | Naga					| Initial Design
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
CREATE PROCEDURE [dbo].[spv_Update_RhythmJobStatus]
				@JobNumber			VARCHAR(20),
				@Status				SMALLINT,
				@StatusDate			DATETIME,
				@Path				VARCHAR(200)
AS
BEGIN

		SET NOCOUNT ON;

		-- Insert the job status to StatusB table
		INSERT INTO dbo.JobStatusB
				( JobNumber, Status, StatusDate, Path )
		VALUES  ( @JobNumber, @Status, @StatusDate, @Path)

		-- Delete the corresponding row from StatusA table
		DELETE FROM dbo.JobStatusA
		WHERE JobNumber = @JobNumber

		-- Update the job status in Jobs table
		UPDATE dbo.Jobs
		SET JobStatus = @Status, JobStatusDate = @StatusDate
		WHERE JobNumber = @JobNumber

		-- Add a Jobs Tracking entry
		INSERT INTO dbo.JobTracking
		        ( JobNumber, Status, StatusDate, Path )
		VALUES  ( @JobNumber, @Status, @StatusDate, @Path)

END
GO
