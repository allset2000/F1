SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************    
** File:  spCreateJobFromSRETransCoding.sql    
** Name:  spCreateJobFromSRETransCoding    
** Desc:  Insert hosted data into the backend tables    
** Auth:  Suresh    
** Date:  18/May/2015    
**************************    
** Change History    
*************************    
* PR   Date     Author  Description     
* --   --------   -------   ------------------------------------    
**   exec spCreateJobFromSRETransCoding  
*******************************/
CREATE PROCEDURE [dbo].[spCreateJobFromSRETransCoding]    
(    
 @xmlJobsClient XML,
 @xmlJobs XML,
 @xmlJobsPatients XML,
 @xmlJobsReferring XML,
 @xmlJobsCustom XML,
 @xmlJobsImages XML,
 @xmlJobTracking XML,
 @vbitIsNoVR bit
 )     
AS    
BEGIN TRY    
	BEGIN TRANSACTION  
	DECLARE @JobNumber  VARCHAR(20)
	DECLARE @Status  INT

	SELECT @JobNumber =  Client.value('JobNumber[1]','VARCHAR(20)') 
	FROM @xmlJobsClient.nodes('JobsClient')Catalog(Client)

	--Insert hosted data into backend Jobs_Client table
	INSERT INTO Jobs_Client(JobNumber,DictatorID,FileName,MD5)
	SELECT Client.value('JobNumber[1]','VARCHAR(20)') AS JobNumber,Client.value('DictatorID[1]','VARCHAR(50)') AS DictatorID,Client.value('FileName[1]','VARCHAR(100)') AS FileName,
		Client.value('MD5[1]','VARCHAR(100)') AS MD5
	FROM @xmlJobsClient.nodes('JobsClient')Catalog(Client)

	--Insert hosted data into backend Jobs table
	INSERT INTO Jobs(JobNumber,DictatorID,ClinicID,Location,AppointmentDate,AppointmentTime,JobType,ContextName,Vocabulary,Stat,Duration,DictationDate,DictationTime,ReceivedOn,IsGenericJob,IsNewSchema,RecServer,RhythmWorkFlowID,TagMetaData)
	SELECT Jobs.value('JobNumber[1]','VARCHAR(20)') AS JobNumber,Jobs.value('DictatorID[1]','VARCHAR(50)') AS DictatorID, Jobs.value('ClinicID[1]','smallint') AS ClinicID,
		Jobs.value('Location[1]','smallint') AS Location,Jobs.value('AppointmentDate[1]','smalldatetime') AS AppointmentDate,Jobs.value('AppointmentTime[1]','smalldatetime') AS AppointmentTime,
		Jobs.value('JobType[1]','VARCHAR(100)') AS JobType,Jobs.value('ContextName[1]','VARCHAR(100)') AS ContextName,Jobs.value('Vocabulary[1]','VARCHAR(255)') AS Vocabulary,
		Jobs.value('Stat[1]','bit') AS Stat,Jobs.value('Duration[1]','smallint') AS Duration,Jobs.value('DictationDate[1]','smalldatetime') AS DictationDate,
		Jobs.value('DictationTime[1]','smalldatetime') AS DictationTime,Jobs.value('ReceivedOn[1]','datetime') AS ReceivedOn,Jobs.value('IsGenericJob[1]','bit') AS IsGenericJob,
		Jobs.value('IsNewSchema[1]','bit') AS IsNewSchema,Jobs.value('RecServer[1]','VARCHAR(50)') AS RecServer,jobs.value('RhythmWorkFlowID[1]','INT') AS RhythmWorkFlowID,jobs.value('TagMetaData[1]','VARCHAR(2000)') AS TagMetaData
	FROM @xmlJobs.nodes('Jobs')Catalog(Jobs)

	--Insert hosted data into backed Jobs_Patients table
	INSERT INTO Jobs_Patients(JobNumber,AlternateID,MRN,FirstName,MI,LastName,DOB,Address1,Address2,City,State,Zip,Sex)
	SELECT Patients.value('JobNumber[1]','VARCHAR(20)') AS JobNumber,Patients.value('AlternateID[1]','VARCHAR(50)') AS AlternateID, Patients.value('MRN[1]','VARCHAR(50)') AS MRN,
		Patients.value('FirstName[1]','VARCHAR(50)') AS FirstName,Patients.value('MI[1]','VARCHAR(50)') AS MI,Patients.value('LastName[1]','VARCHAR(50)') AS LastName,
		Patients.value('DOB[1]','VARCHAR(50)') AS DOB,Patients.value('Address1[1]','VARCHAR(100)') AS Address1,Patients.value('Address2[1]','VARCHAR(100)') AS Address2,
		Patients.value('City[1]','VARCHAR(50)') AS City,Patients.value('State[1]','VARCHAR(50)') AS State,Patients.value('Zip[1]','VARCHAR(50)') AS Zip,
		Patients.value('Sex[1]','VARCHAR(10)') AS Sex
	FROM @xmlJobsPatients.nodes('JobsPatients')Catalog(Patients)

	--Insert hosted data into Jobs_Referring table
	INSERT INTO Jobs_Referring(JobNumber,PhysicianID,FirstName,MI,LastName,Sex,Address1,Address2,City,State,Zip,DOB,SSN,Phone,Fax)
	SELECT Referring.value('JobNumber[1]','VARCHAR(20)') AS JobNumber,Referring.value('PhysicianID[1]','VARCHAR(50)') AS PhysicianID,Referring.value('FirstName[1]','VARCHAR(50)') AS FirstName,
		Referring.value('MI[1]','VARCHAR(50)') AS MI,Referring.value('LastName[1]','VARCHAR(50)') AS LastName,Referring.value('Sex[1]','VARCHAR(10)') AS Sex,
		Referring.value('Address1[1]','VARCHAR(100)') AS Address1,Referring.value('Address2[1]','VARCHAR(100)') AS Address2,Referring.value('City[1]','VARCHAR(50)') AS City,
		Referring.value('State[1]','VARCHAR(50)') AS State,Referring.value('Zip[1]','VARCHAR(50)') AS Zip,Referring.value('DOB[1]','VARCHAR(50)') AS DOB,
		Referring.value('SSN[1]','VARCHAR(50)') AS SSN,Referring.value('Phone[1]','VARCHAR(20)') AS Phone,Referring.value('Fax[1]','VARCHAR(50)') AS Fax
	FROM @xmlJobsReferring.nodes('JobsReferring')Catalog(Referring)

	--Insert hosted data into backend Jobs_Custom table   
	INSERT INTO Jobs_Custom 
	SELECT Custom.value('JobNumber[1]','VARCHAR(20)') AS JobNumber,Custom.value('Custom1[1]','VARCHAR(100)') AS Custom1,Custom.value('Custom2[1]','VARCHAR(100)') AS Custom2,
		Custom.value('Custom3[1]','VARCHAR(100)') AS Custom3,Custom.value('Custom4[1]','VARCHAR(100)') AS Custom4,Custom.value('Custom5[1]','VARCHAR(100)') AS Custom5,
		Custom.value('Custom6[1]','VARCHAR(100)') AS Custom6,Custom.value('Custom7[1]','VARCHAR(100)') AS Custom7,Custom.value('Custom8[1]','VARCHAR(100)') AS Custom8,
		Custom.value('Custom9[1]','VARCHAR(100)') AS Custom9,Custom.value('Custom10[1]','VARCHAR(100)') AS Custom10,Custom.value('Custom11[1]','VARCHAR(100)') AS Custom11,
		Custom.value('Custom12[1]','VARCHAR(100)') AS Custom12,Custom.value('Custom13[1]','VARCHAR(100)') AS Custom13,Custom.value('Custom14[1]','VARCHAR(100)') AS Custom14,
		Custom.value('Custom15[1]','VARCHAR(100)') AS Custom15,Custom.value('Custom16[1]','VARCHAR(100)') AS Custom16,Custom.value('Custom17[1]','VARCHAR(100)') AS Custom17,
		Custom.value('Custom18[1]','VARCHAR(100)') AS Custom18,Custom.value('Custom19[1]','VARCHAR(100)') AS Custom19,Custom.value('Custom20[1]','VARCHAR(100)') AS Custom20,
		Custom.value('Custom21[1]','VARCHAR(100)') AS Custom21,Custom.value('Custom22[1]','VARCHAR(100)') AS Custom22,Custom.value('Custom23[1]','VARCHAR(100)') AS Custom23,
		Custom.value('Custom24[1]','VARCHAR(100)') AS Custom24,Custom.value('Custom25[1]','VARCHAR(100)') AS Custom25,Custom.value('Custom26[1]','VARCHAR(100)') AS Custom26,
		Custom.value('Custom27[1]','VARCHAR(100)') AS Custom27,Custom.value('Custom28[1]','VARCHAR(100)') AS Custom28,Custom.value('Custom29[1]','VARCHAR(100)') AS Custom29,
		Custom.value('Custom30[1]','VARCHAR(100)') AS Custom30,Custom.value('Custom31[1]','VARCHAR(100)') AS Custom31,Custom.value('Custom32[1]','VARCHAR(100)') AS Custom32,
		Custom.value('Custom33[1]','VARCHAR(100)') AS Custom33,Custom.value('Custom34[1]','VARCHAR(100)') AS Custom34,Custom.value('Custom35[1]','VARCHAR(100)') AS Custom35,
		Custom.value('Custom36[1]','VARCHAR(100)') AS Custom36,Custom.value('Custom37[1]','VARCHAR(100)') AS Custom37,Custom.value('Custom38[1]','VARCHAR(100)') AS Custom38,    
		Custom.value('Custom39[1]','VARCHAR(100)') AS Custom39,Custom.value('Custom40[1]','VARCHAR(100)') AS Custom40,Custom.value('Custom41[1]','VARCHAR(100)') AS Custom41,
		Custom.value('Custom42[1]','VARCHAR(100)') AS Custom42,Custom.value('Custom43[1]','VARCHAR(100)') AS Custom43,Custom.value('Custom44[1]','VARCHAR(100)') AS Custom44,
		Custom.value('Custom45[1]','VARCHAR(100)') AS Custom45,Custom.value('Custom46[1]','VARCHAR(100)') AS Custom46,Custom.value('Custom47[1]','VARCHAR(100)') AS Custom47,
		Custom.value('Custom48[1]','VARCHAR(100)') AS Custom48,Custom.value('Custom49[1]','VARCHAR(100)') AS Custom49,Custom.value('Custom50[1]','VARCHAR(100)') AS Custom50
	FROM @xmlJobsCustom.nodes('JobsCustom')Catalog(Custom)

	--Insert hosted data into backend Jobs_Images table 
	IF (@xmlJobsImages is not null)
		INSERT INTO Jobs_Images(JobNumber,ImagePath)
		SELECT Images.value('JobNumber[1]','VARCHAR(20)') AS JobNumber,Images.value('ImagePath[1]','VARCHAR(200)') AS DictatorID
		FROM @xmlJobsImages.nodes('/JobsImages/JobsImage')Catalog(Images)

	--Insert hosted data into backend JobTracking table with status 100
	INSERT INTO JobTracking(JobNumber,Status,StatusDate,Path)
	SELECT JobTracking.value('JobNumber[1]','VARCHAR(20)') AS JobNumber,JobTracking.value('Status[1]','smallint') AS Status,JobTracking.value('StatusDate[1]','datetime') AS StatusDate,
	   JobTracking.value('Path[1]','VARCHAR(255)') AS Path
	FROM @xmlJobTracking.nodes('JobTracking')Catalog(JobTracking)

	--Insert hosted data into backend JobTracking table with status 110   
	INSERT INTO JobTracking(JobNumber,Status,StatusDate,Path)
	SELECT JobTracking.value('JobNumber[1]','VARCHAR(20)') AS JobNumber,110 AS Status,getdate() as StatusDate,
		JobTracking.value('Path[1]','VARCHAR(255)') AS Path
	FROM @xmlJobTracking.nodes('JobTracking')Catalog(JobTracking)

	--Insert hosted data into backend JobTracking table with status 140 if sretypeid is null or 0(NoVR)
	IF (@vbitIsNoVR =1)
	BEGIN
		INSERT INTO JobTracking(JobNumber,Status,StatusDate,Path)
		SELECT JobTracking.value('JobNumber[1]','VARCHAR(20)') AS JobNumber,140 AS Status,getdate() as StatusDate,
		JobTracking.value('Path[1]','VARCHAR(255)') AS Path
		FROM @xmlJobTracking.nodes('JobTracking')Catalog(JobTracking)
		SET @Status = 140
	END 
	ELSE
		SET @Status = 110

	--Insert data into JobStatusA table 
	INSERT INTO JobStatusA(JobNumber,Status,StatusDate,Path)
	SELECT JobTracking.value('JobNumber[1]','VARCHAR(20)') AS JobNumber,@Status AS Status,JobTracking.value('StatusDate[1]','datetime') AS StatusDate,
		JobTracking.value('Path[1]','VARCHAR(255)') AS Path
	FROM @xmlJobTracking.nodes('JobTracking')Catalog(JobTracking)

	--Insert data into OrphanJobs table	
	INSERT INTO OrphanJobsToProcess(JobNumber,CreatedOn)
	VALUES(@JobNumber,getdate())

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
