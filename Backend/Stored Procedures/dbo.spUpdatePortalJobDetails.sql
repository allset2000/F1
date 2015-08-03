/******************************  
** File:  spUpdatePortalJobDetails.sql  
** Name:  spUpdatePortalJobDetails  
** Desc:  Update the  jobs details 
** Auth:  Suresh  
** Date:  13/July/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
CREATE PROCEDURE [dbo].[spUpdatePortalJobDetails]  
(  
 @vvcrJobNumber VARCHAR(20),
 @vvcrJobType VARCHAR(100) ,
 @vbitStat BIT,
 @vintPatientId  INT,
 @vvcrAlternateID  VARCHAR(50),
 @vvcrMRN  VARCHAR(50),
 @vvcrFirstName  VARCHAR(50),
 @vvcrMI  VARCHAR(50),
 @vvcrLastName  VARCHAR(50),
 @vvcrSuffix  VARCHAR(50),
 @vvcrDOB  VARCHAR(50),
 @vvcrSSN  VARCHAR(50),
 @vvcrAddress1  VARCHAR(100),
 @vvcrAddress2 VARCHAR(100),
 @vvcrCity  VARCHAR(50),
 @vvcrState  VARCHAR(50),
 @vvcrZip  VARCHAR(50),
 @vvcrPhone  VARCHAR(50),
 @vvcrSex  VARCHAR(10),
 @vintAppointmentId  INT,
 @vnitIsApproved Bit,
 @vnvcrDocumnet NVARCHAR(MAX),
 @vvcrUsername VARCHAR(200),
 @vvcrLastQANote VARCHAR(255) 
)  
AS  
BEGIN TRY 
	DECLARE @currentDate DATETIME
	DECLARE @jobID INT
	DECLARE @documentId INT = NULL
	DECLARE @Status INT
	DECLARE @UserId INT
	DECLARE @vbinDocumnet VARBINARY(MAX)
	SET @currentDate = GETDATE()
	SET @vbinDocumnet =  CAST(@vnvcrDocumnet as varbinary(MAX))
	BEGIN TRANSACTION 
		-- Updating Patient Details
		IF @vvcrMRN <> '' 
		BEGIN
			EXEC dbo.writePatient @vintPatientId,@vvcrJobNumber,@vvcrAlternateID,@vvcrMRN, @vvcrFirstName, @vvcrMI,@vvcrLastName,@vvcrSuffix,@vvcrDOB,
									  @vvcrSSN,@vvcrAddress1,@vvcrAddress2,@vvcrCity,@vvcrState,@vvcrZip,@vvcrPhone,@vvcrSex,@vintAppointmentId  
		END 
		-- Updating JobType and stat details into jobs table
		IF @vvcrJobType <> ''
		BEGIN
			UPDATE Jobs SET JobType = @vvcrJobType , Stat = @vbitStat WHERE ([JobNumber] = @vvcrJobNumber)
			EXEC dbo.doUpdateJobDueDate @vvcrJobNumber, 'SaveJob'
			IF (@vvcrJobType = 'no delivery')
				exec writeJ2D @vvcrJobNumber
		END
		--updating document into jobs_documents table
		IF @vbinDocumnet IS NOT Null
			BEGIN
				IF @vnitIsApproved = 0 
					EXEC doUpdateJobDocument @vvcrJobNumber, @vbinDocumnet,@vvcrUsername,@currentDate
				ELSE IF @vnitIsApproved = 1 
					EXEC doApproveDocumentByCR @vvcrJobNumber, @vbinDocumnet,@vvcrUsername,@currentDate
				SELECT @documentID = DocumentId FROM Jobs_Documents_History WHERE jobnumber=@vvcrJobNumber AND Username=@vvcrUsername AND DocDate = @currentDate
			END 
		Else if  @vbinDocumnet IS Null AND @vnitIsApproved = 1 
			BEGIN
					UPDATE JobStatusA SET [Status] = 250,StatusDate = @currentDate WHERE JobNumber = @vvcrJobNumber;

					INSERT INTO [dbo].[JobTracking]	([JobNumber], [Status], [StatusDate], [Path])		
					SELECT [JobNumber], [Status], [StatusDate], [Path] 
					FROM [dbo].JobStatusA
					WHERE (JobNumber = @vvcrJobNumber)
			END
		-- updating QA Notes into jobEditingsummery table
		IF @vvcrLastQANote <> ''
		BEGIN 
			IF NOT EXISTS(SELECT * FROM [dbo].[JobEditingSummary] WHERE ([JobId] = @JobId))
			BEGIN 
				SELECT @jobID=JobId FROM jobs WHERE JobNumber = @vvcrJobNumber
				UPDATE JobEditingSummary SET LastQANote = @vvcrLastQANote WHERE JobId= @jobID 
			END
		END
		select @Status = status from JobStatusA where jobnumber=@vvcrJobNumber
		if(@Status is NULL )
			select @Status = status from JobStatusB where jobnumber=@vvcrJobNumber
		select @UserId = ContactId from Contacts where UserID=@vvcrUsername
		EXEC spInsertJobHistory @vvcrJobNumber,@vvcrMRN,@vvcrJobType,@Status,@documentID,@UserId
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 
	   BEGIN
			ROLLBACK TRANSACTION
			DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
			SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
			RAISERROR(@ErrMsg, @ErrSeverity, 1)
		END
END CATCH 

