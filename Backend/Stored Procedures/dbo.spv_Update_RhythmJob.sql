
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
--XX  Entrada Inc
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
--X PROCEDURE: [spv_Update_RhythmJob]
--X
--X AUTHOR: Naga
--X
--X DESCRIPTION: Stored procedure to update the rhythm job details and status
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
--X   0    | 04/28/2016   | Naga					| Initial Design
--X   1    | 05/09/2016   | Naga					| #5457 - Included the Document Status column, so that the update the can be done in the same stored procedure
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
CREATE PROCEDURE [dbo].[spv_Update_RhythmJob]
				@JobNumber				VARCHAR(20),
				@JobStatus				SMALLINT,
				@DocumentStatus			SMALLINT,
				@UpdatedBy				VARCHAR(50),
				@TemplateName			VARCHAR(100),
				@DocBinary				VARBINARY(MAX),
				@FilePath				VARCHAR(200)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @PatientFirstName			VARCHAR(50),
			@PatientLastName			VARCHAR(50),
			@PatientMiddleName			VARCHAR(50),
			@PatientMRN					VARCHAR(50),
			@PatientDOB					VARCHAR(50),
			@JobType					VARCHAR(50),
			@CurrentJobStatus			SMALLINT,
			@StatusDate					DATETIME

	-- initialize the status date
	SET @StatusDate = GETDATE()

	-- get the patient demographic information based on the job number
	SELECT @PatientFirstName = ISNULL(FirstName, ''), @PatientLastName = ISNULL(LastName, ''), @PatientMiddleName = ISNULL(MI, ''), @PatientDOB = DOB, @PatientMRN = MRN
	FROM dbo.Jobs_Patients
	WHERE JobNumber = @JobNumber

	-- get the job details based on job number
	SELECT @JobType = JobType, @CurrentJobStatus = JobStatus FROM dbo.Jobs
	WHERE JobNumber = @JobNumber

	-- add a job history record with current job status
	EXEC spInsertJobHistory @vvcrJobNumber = @JobNumber, @vvcrMRN = @PatientMRN, @vvcrJobType = @JobType, @vsintCurrentStatus = @CurrentJobStatus,
							@vvcrUserId = @UpdatedBy, @vvcrFirstName = @PatientFirstName, @vvcrMI = @PatientMiddleName, @vvcrLastName = @PatientLastName, 
							@vvcrDOB = @PatientDOB


	-- if a job document already exist, then move it history table
	IF EXISTS (SELECT 1 FROM dbo.Jobs_Documents WHERE JobNumber = @JobNumber)
	BEGIN
		INSERT INTO dbo.Jobs_Documents_History
		        ( JobNumber , Doc , XmlData , Username , DocDate , DocumentIdOk , DocumentTypeId , DocumentStatusId , JobId , TemplateName , [Status] , StatusDate )
		SELECT  JobNumber , Doc , XmlData , Username , DocDate , 0 , DocumentTypeId , DocumentStatusId , JobId , @TemplateName , [Status] , StatusDate 
			FROM dbo.Jobs_Documents WHERE JobNumber = @JobNumber

		DELETE FROM dbo.Jobs_Documents WHERE JobNumber = @JobNumber
	END

	-- insert the new job document entry with latest document binary
	INSERT INTO dbo.Jobs_Documents
			( JobNumber , Doc , XmlData , Username , DocDate , DocumentId , DocumentTypeId , DocumentStatusId , JobId , [Status] , StatusDate )
	VALUES  
			( @JobNumber , @DocBinary , NULL , @UpdatedBy , @StatusDate , 0 , 0 , 0 , 0 , 0 , @StatusDate )


	-- add an entry to DocumentToProcess table
	INSERT INTO dbo.DocumentsToProcess
	        ( JobNumber, ProcessFailureCount )
	VALUES  ( @JobNumber, 0 )

	-- insert the new jobs status to JobStatusB table
	INSERT INTO dbo.JobStatusB
			( JobNumber, [Status], StatusDate, [Path] )
	VALUES  ( @JobNumber, @JobStatus, @StatusDate, @FilePath)

	-- Delete the corresponding old job status from StatusA table
	DELETE FROM dbo.JobStatusA
	WHERE JobNumber = @JobNumber

	-- Update the new job status in Jobs table
	UPDATE dbo.Jobs
	SET JobStatus = @JobStatus, JobStatusDate = @StatusDate, DocumentStatus = @DocumentStatus
	WHERE JobNumber = @JobNumber

	-- Add a Jobs Tracking entry
	INSERT INTO dbo.JobTracking
		    ( JobNumber, [Status], StatusDate, [Path] )
	VALUES  ( @JobNumber, @JobStatus, @StatusDate, @FilePath)

	-- update the new job status to hosted database
	EXEC spUpdateBackendStatusAndDateIntoHosted @vvcrJobNumber = @JobNumber, @vsintStatus = @JobStatus


END
GO
