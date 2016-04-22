
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Narender
-- Create date: 05-APR-2016
-- Description:	This procedure will update the job_history table when we Approve/Sent to Transcription from Mobile for Chubbs Jobs
-- =============================================
--EXEC [spv_UpdateJobHistoryForDraftViewJobs] '2016041400000003', 1,'narenderr'

CREATE PROCEDURE [dbo].[spv_UpdateJobHistoryForDraftViewJobs] 
@Jobnumber varchar(20),
@Operation int,
@UserName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		--DECLARE @MRN VARCHAR(50) DECLARE @JOBTYPE VARCHAR(100) DECLARE @CURRENTSTATUS SMALLINT DECLARE @USERID VARCHAR(48) 
		IF(@Operation = 1) --- 1 means job approved from Mobile
		INSERT INTO Job_History  SELECT TOP 1  JOBNUMBER, MRN, JOBTYPE, 138 ,NULL, @UserName, GETDATE(), 
			FIRSTNAME, MI, LASTNAME, DOB, ISHISTORY, STAT, 1, NULL FROM Job_History WHERE JobNumber = @Jobnumber ORDER BY JobHistoryID DESC
		IF(@Operation = 2) --- 2 means job Sent to Transcription from Mobile
		INSERT INTO Job_History  SELECT TOP 1  JOBNUMBER, MRN, JOBTYPE, 140 ,NULL, @UserName, GETDATE(), 
			FIRSTNAME, MI, LASTNAME, DOB, ISHISTORY, STAT, 1, NULL FROM Job_History WHERE JobNumber = @Jobnumber ORDER BY JobHistoryID DESC
END
GO
