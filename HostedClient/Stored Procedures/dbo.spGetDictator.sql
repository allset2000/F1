/******************************  
** File:  spGetDictator.sql  
** Name:  spGetDictator  
** Desc:  Get Dictator based on dictator ID 
** Auth:  Suresh  
** Date:  18/May/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
CREATE PROCEDURE [dbo].[spGetDictator]  
(  
 @vintDictatorID  INT  
)  
AS  
BEGIN 
	
	SELECT DictatorID,
		DictatorName,
		ClinicID,
		Deleted,
		DefaultJobTypeID,
		Password,
		Salt,
		FirstName,
		MI,
		LastName,
		Suffix,
		Initials,
		Signature,
		EHRProviderID,
		EHRProviderAlias,
		DefaultQueueID,
		VRMode,
		CRFlagType,
		ForceCRStartDate,
		ForceCREndDate,
		ExcludeStat,
		SignatureImage,
		ImageName,
		UserId,
		SRETypeId
	FROM Dictators 
	WHERE DictatorID =  @vintDictatorID

END  

  