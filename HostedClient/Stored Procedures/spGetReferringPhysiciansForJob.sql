/******************************  
** File:  spGetReferringPhysiciansForJob.sql  
** Name:  spGetReferringPhysiciansForJob  
** Desc:  Get Referring Physicians based on job id 
** Auth:  Suresh  
** Date:  18/May/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
spEntradadropStoredProcedure 'spGetReferringPhysiciansForJob'
GO
CREATE PROCEDURE [dbo].[spGetReferringPhysiciansForJob] 
(  
 @vintJobID BIGINT
)  
AS  
BEGIN 

	SELECT RF.ReferringID,
	RF.ClinicID,
	RF.PhysicianID,
	RF.FirstName,
	RF.MI,
	RF.LastName,
	RF.Suffix,
	RF.Gender,
	RF.Address1,
	RF.Address2,
	RF.City,
	RF.State,
	RF.Zip,
	RF.Phone1,
	RF.Phone2,
	RF.DOB,
	RF.SSN,
	RF.Fax1,
	RF.Fax2
	FROM ReferringPhysicians RF
	INNER JOIN Jobs_Referring JR
	ON RF.ReferringID = JR.ReferringID 
	WHERE JR.JobID = @vintJobID
END  
GO  
