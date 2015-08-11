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
*******************************/      
      
CREATE PROCEDURE [dbo].[spGetPortalJobDetails] 
(          
 @vvcrJobNumber VARCHAR(20),
 @vvcrUser VARCHAR(48)      
)           
AS          
BEGIN     

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
		JB.LokedbyUserForJobDetailsView
	FROM jobs JB
	INNER JOIN Jobs_Patients JP
	ON JB.jobnumber = JP.jobnumber
	INNER JOIN Dictators D
	ON JB.DictatorID = D.DictatorID
	INNER JOIN Jobs_Referring JR
	ON JB.jobnumber = JR.jobnumber
	WHERE JB.JobNumber=@vvcrJobNumber

 --In case when this proc is executed in parallel by multiple instances of the SRE App we need  
 --to make sure we don't return the same job twice  
 
 UPDATE jobs SET LokedbyUserForJobDetailsView=@vvcrUser WHERE jobnumber=@vvcrJobNumber AND LokedbyUserForJobDetailsView IS NULL


END   
