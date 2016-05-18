SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************          
** File:  spGetPortalJobDetails.sql          
** Name:  spGetPortalJobDetails          
** Desc:  Get the Job details based on job number
** Auth:  Suresh          
** Date:  15/Jun/2015          
**************************          
** Change History          
*************************          
* PR   Date     Author  Description           
* --   --------   -------   ------------------------------------      
* 5909 11-May-2016 baswaraj Added IsJobDelivered column to hold the jobdelivered status 
* 8394 18-May-2016 baswaraj Added DocumentStatus column return for to check the DocumentLock status.
*******************************/      
      
CREATE PROCEDURE [dbo].[spGetPortalJobDetails] 
(          
 @vvcrJobNumber VARCHAR(20),
 @vvcrUser VARCHAR(48),
 @vvcrIsJobLockable bit = null
)           
AS          
BEGIN     
DECLARE @Status INT
	SELECT @Status = status FROM JobStatusA WHERE jobnumber=@vvcrJobNumber
	IF(@Status is NULL )
		SELECT @Status = status FROM JobStatusB WHERE jobnumber=@vvcrJobNumber
DECLARE @IsJobDelivered bit=0
    IF EXISTS(SELECT * FROM JobDeliveryHistory where jobnumber=@vvcrJobNumber)
       SET @IsJobDelivered=1

IF EXISTS( SELECT 1 FROM jobs WHERE jobnumber=@vvcrJobNumber AND DATEDIFF(MINUTE, LockbyUserTimeStamp, GETDATE())  > 30 AND (LokedbyUserForJobDetailsView IS NOT NULL OR LokedbyUserForJobDetailsView = ''))
 UPDATE jobs SET LokedbyUserForJobDetailsView = null, LockbyUserTimeStamp=null WHERE jobnumber=@vvcrJobNumber

	SELECT JB.jobnumber, 
		JP.PatientId,
		JP.MRN,
		JP.FirstName,
		JP.MI,
		JP.LastName,
		JP.dob,
		JP.Address1,
		JP.Address2,
		JP.City,
		JP.State,
		JP.Zip,
		JB.AppointmentDate,
		JB.AppointmentTime,
		JB.JobType,
		JB.stat,
		JB.IsGenericJob,
		JB.DictatorID,
		JB.ClinicID,
		D.FirstName AS DictatorFirstName,
		ISNULL(D.MI, '') AS DictatorMI,
		D.LastName AS DictatorLastName,
		ISNULL(JR.FirstName, '') AS ReferringFirstName, 
		ISNULL(JR.MI, '') AS ReferringMI, 
		ISNULL(JR.LastName, '') ReferringLastName,
		JB.LokedbyUserForJobDetailsView,
		@Status Status,
		JA.FileArchivedOn,
		JE.LastQANote,
		JB.AppointmentId,
		JP.SSN,
		@IsJobDelivered as IsJobDelivered,
		ISNULL(JB.DocumentStatus,0) AS DocumentStatus
	FROM jobs JB
	INNER JOIN Jobs_Patients JP
	ON JB.jobnumber = JP.jobnumber
	INNER JOIN Dictators D
	ON JB.DictatorID = D.DictatorID
	INNER JOIN Jobs_Referring JR
	ON JB.jobnumber = JR.jobnumber
	LEFT OUTER JOIN Jobs_ArchiveDetails JA
	ON JB.jobnumber = JA.jobnumber
	LEFT OUTER JOIN JobEditingSummary JE
	ON JB.JobId = JE.JobId
	WHERE JB.JobNumber=@vvcrJobNumber

 --In case when this proc is executed in parallel by multiple instances of the CustomerPortal App we need  
 --to make sure we don't return the same job twice  
 declare @isJobCanBeUpdatedFromPortal bit 

	if((@Status >= 100 and @Status <= 140) or (@Status = 240) or (@Status >= 270 and @Status <= 360))
		set @isJobCanBeUpdatedFromPortal = 1
	else 
		set @isJobCanBeUpdatedFromPortal = 0

 UPDATE jobs SET LokedbyUserForJobDetailsView=@vvcrUser,LockbyUserTimeStamp=getdate() WHERE jobnumber=@vvcrJobNumber AND (@isJobCanBeUpdatedFromPortal = 1 AND @vvcrIsJobLockable = 1) AND (LokedbyUserForJobDetailsView  IS NULL OR LokedbyUserForJobDetailsView = '')

END   
GO
