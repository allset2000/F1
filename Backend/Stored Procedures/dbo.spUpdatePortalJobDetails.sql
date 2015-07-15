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
 @vdtAppointmentDate DATETIME,
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
 @vbinDocumnet varbinary(max),
 @vvcrUsername VARCHAR(200),
 @vvcrLastQANote VARCHAR(255) 
)  
AS  
BEGIN TRY 
	DECLARE @currentDate DATETIME
	DECLARE @jobID INT
	SET @currentDate = GETDATE()
	BEGIN TRANSACTION 
		
		-- Updating Patient Details
		IF @vintPatientId <> 0 
		BEGIN
			EXEC dbo.writePatient @vintPatientId,@vvcrJobNumber,@vvcrAlternateID,@vvcrMRN, @vvcrFirstName, @vvcrMI,@vvcrLastName,@vvcrSuffix,@vvcrDOB,
									  @vvcrSSN,@vvcrAddress1,@vvcrAddress2,@vvcrCity,@vvcrState,@vvcrZip,@vvcrPhone,@vvcrSex,@vintAppointmentId  
		END 

		-- Updating JobType and stat details into jobs table
		IF @vvcrJobType <> ''
		BEGIN
			UPDATE Jobs SET AppointmentDate = @vdtAppointmentDate ,JobType = @vvcrJobType , Stat = @vbitStat WHERE ([JobNumber] = @vvcrJobNumber)

			EXEC dbo.doUpdateJobDueDate @vvcrJobNumber, 'SaveJob'
			
			IF (@vvcrJobType = 'no delivery')
				exec writeJ2D @vvcrJobNumber
		END
		
		--updating document into jobs_documents table
		IF @vbinDocumnet <> Null
		BEGIN
			IF @vnitIsApproved = 0 
				EXEC doUpdateJobDocument @vvcrJobNumber, @vbinDocumnet,@vvcrUsername,@currentDate
			ELSE IF @vnitIsApproved = 1 
				EXEC doApproveDocumentByCR @vvcrJobNumber, @vbinDocumnet,@vvcrUsername,@currentDate
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

