
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************  
** File:  spUpdatePortalJobDetails.sql  
** Name:  spUpdatePortalJobDetails  
** Desc:  Update the  jobs details 
** Auth:  Suresh  
** Date:  13/July/2015  
**************************  
** Change History  
	Modifiyed By: Mikayil Bayramov (Mika)
	Midification Date: 11/17/2015
	Modification Description: With previous implementation when job type was 'no delivery',
	                          then it would be deleted form JobsToDeliver table. 
							  In new implementation, the job is also deleted from JobsToDeliverErrors table.
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
** 1    25-FEB-2016 Narender: #731# Added STAT Field to insert into Job History
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
	DECLARE @Status INT=NULL
	DECLARE @UserId INT
	DECLARE @vbinDocumnet VARBINARY(MAX)
	SET @currentDate = GETDATE()
	SET @vbinDocumnet =  CAST(@vnvcrDocumnet as varbinary(MAX))
	DECLARE @oldMRN VARCHAR(50) =null
	DECLARE @oldJobType VARCHAR(100) =null
	DECLARE @oldStatus INT=null
	DECLARE @vbitStat1 BIT=null

	BEGIN TRANSACTION 
		-- Updating Patient Details
		IF @vvcrMRN = '' OR @vvcrMRN = '0'
			set @vvcrMRN =null

		IF(@vbitStat = 1)
			set @vbitStat1 = 1
		ELSE
			set @vbitStat1 = NULL

			-- Update the Stat value
		IF NOT EXISTS(SELECT * FROM Jobs WHERE JobNumber = @vvcrJobNumber and Stat = @vbitStat) 
		BEGIN
			UPDATE Jobs SET Stat = @vbitStat WHERE ([JobNumber] = @vvcrJobNumber)
		END
		ELSE
			set @vbitStat1 = NULL

		-- Tracking the previous status details
		EXEC [spInsertJobHistory] @vvcrJobNumber,null,null,null,null,@vvcrUsername,null,null,null,null,null

		select @oldStatus = status from JobStatusA where jobnumber=@vvcrJobNumber
		if(@oldStatus is NULL )
			select @oldStatus = status from JobStatusB where jobnumber=@vvcrJobNumber

		IF(@vbitStat1 = 1)
		INSERT INTO Job_History(JobNumber, CurrentStatus,UserId, HistoryDateTime,IsHistory, STAT ) VALUES (@vvcrJobNumber,@oldStatus,@vvcrUsername,GETDATE(),0, @vbitStat1)

		-- Update the Patient		
		IF @vvcrMRN is not null
		BEGIN
			--SELECT @oldMRN=MRN FROM Jobs_Patients where jobnumber=@vvcrJobNumber
			EXEC dbo.writePatient @vintPatientId,@vvcrJobNumber,@vvcrAlternateID,@vvcrMRN, @vvcrFirstName, @vvcrMI,@vvcrLastName,@vvcrSuffix,@vvcrDOB,
									  @vvcrSSN,@vvcrAddress1,@vvcrAddress2,@vvcrCity,@vvcrState,@vvcrZip,@vvcrPhone,@vvcrSex,@vintAppointmentId  
			
		END 

		-- Updating JobType and stat details into jobs table
		IF @vvcrJobType <> ''
		BEGIN
			--select @oldJobType=JobType from jobs WHERE ([JobNumber] = @vvcrJobNumber)
			UPDATE Jobs SET JobType = @vvcrJobType  WHERE ([JobNumber] = @vvcrJobNumber)
			EXEC dbo.doUpdateJobDueDate @vvcrJobNumber, 'SaveJob'

			IF (LOWER(@vvcrJobType) like '%no delivery%') BEGIN
				DECLARE @deliveryID AS INT

				SELECT @deliveryID = DeliveryID 
			    FROM [dbo].[JobsToDeliver] 
				WHERE JobNumber = @vvcrJobNumber

				DELETE FROM [dbo].[JobsToDeliver] 
				WHERE JobNumber = @vvcrJobNumber

			    DELETE FROM [dbo].[JobsToDeliverErrors]
				WHERE DeliveryID = @deliveryID
			END
		END

	
		--updating document into jobs_documents table
		IF @vbinDocumnet IS NOT Null AND  @oldStatus < 250 OR @oldStatus >= 360 
			BEGIN
				IF @vnitIsApproved = 0 
					EXEC doUpdateJobDocument @vvcrJobNumber, @vbinDocumnet,@vvcrUsername,@currentDate
				ELSE IF @vnitIsApproved = 1 
					EXEC doApproveDocumentByCR @vvcrJobNumber, @vbinDocumnet,@vvcrUsername,@currentDate
				SELECT @documentID = DocumentId FROM Jobs_Documents_History WHERE jobnumber=@vvcrJobNumber AND Username=@vvcrUsername AND DocDate = @currentDate
			END 
		Else if @vbinDocumnet is null and @vnitIsApproved = 1 
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
			SELECT @jobID=JobId FROM jobs WHERE JobNumber = @vvcrJobNumber
			IF NOT EXISTS(SELECT * FROM [dbo].[JobEditingSummary] WHERE ([JobId] = @JobId))
			BEGIN 
				UPDATE JobEditingSummary SET LastQANote = @vvcrLastQANote WHERE JobId= @jobID 
			END
		END

		

	--Get the Current Status 
		select @Status = status from JobStatusA where jobnumber=@vvcrJobNumber
		if(@Status is NULL )
			select @Status = status from JobStatusB where jobnumber=@vvcrJobNumber
		if  @Status=250 
			BEGIN
			INSERT INTO Job_History (JobNumber,MRN,JobType,CurrentStatus,DocumentID,UserId,HistoryDateTime, STAT)
			SELECT @vvcrJobNumber,MRN,JobType,250,null,@vvcrUsername,GETDATE(), @vbitStat1 from jobs j inner join Jobs_Patients p on j.jobnumber=p.jobnumber 
					WHERE (j.[JobNumber] = @vvcrJobNumber)
			END

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

GO
