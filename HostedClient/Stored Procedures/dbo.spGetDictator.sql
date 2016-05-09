
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
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
**      4/5/2016, Raghu A, New columns add  RhythmWorkFlowID, AppSetting_DisableSendToTranscription added
*******************************/  
--Exec [spGetDictator] 2216
CREATE PROCEDURE [dbo].[spGetDictator]  
(  
 @vintDictatorID  INT  
)  
AS  
BEGIN 
	
	SELECT D.DictatorID,
		DictatorName,
		D.ClinicID,
		D.Deleted,
		D.DefaultJobTypeID,
		D.Password,
		D.Salt,
		D.FirstName,
		D.MI,
		D.LastName,
		D.Suffix,
		D.Initials,
		D.Signature,
		D.EHRProviderID,
		D.EHRProviderAlias,
		D.DefaultQueueID,
		D.VRMode,
		D.CRFlagType,
		D.ForceCRStartDate,
		D.ForceCREndDate,
		D.ExcludeStat,
		D.SignatureImage,
		D.ImageName,
		D.UserId,
		D.SRETypeId,
		ISNULL(D.RhythmWorkFlowID,C.RhythmWorkFlowID) AS RhythmWorkFlowID,
        ISNULL(D.AppSetting_DisableSendToTranscription,C.AppSetting_DisableSendToTranscription) AS AppSetting_DisableSendToTranscription,
		D.Preference
	FROM Dictators D
	INNER JOIN clinics c ON C.ClinicID=D.ClinicID
	WHERE DictatorID =  @vintDictatorID

END  

GO
