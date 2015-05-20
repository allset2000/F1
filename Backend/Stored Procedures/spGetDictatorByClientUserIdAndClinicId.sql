/******************************  
** File:  spGetDictatorByClientUserIdAndClinicId.sql  
** Name:  spGetDictatorByClientUserIdAndClinicId  
** Desc:  Get Dictator details based on clinic ID and ClinetUserId 
** Auth:  Suresh  
** Date:  18/May/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
spEntradadropStoredProcedure 'spGetDictatorByDictatoridAndClinic'
GO
CREATE PROCEDURE [dbo].[spGetDictatorByClientUserIdAndClinicId] 
(  
 @ClientUserID varchar(50),
 @vintClinicID  smallint  
)  
AS  
BEGIN 

	SELECT ClinicID,
	DictatorID,
	ClientUserID,
	DefaultLocation,
	FirstName,
	MI,
	LastName,
	Suffix,
	Initials,
	TemplatesFolder,
	Signature,
	User_Code,
	ForkAudio,
	VREnabled,
	Email,
	SignUpDate,
	FirstDictation,
	NumCharsPerLine, 
	PageRate,
	LineRate,
	SecondRate,
	EditPageRate,
	EditLineRate,
	EditSecondRate,
	ClinicReviewEnabled,
	ESignatureEnabled,
	ESignatureStamp,
	ESignatureLocation,
	CloseDocuments,
	NumDaysToClose,
	DictatorIdOk,
	EHRProviderID,
	EHRAliasID,
	ProviderType,
	BillSeparated,
	PhoneNo,
	FaxNo,
	MedicalLicenseNo,
	Custom1,
	Custom2,
	Custom3,
	Custom4,
	Custom5,
	SRETypeId
	FROM Dictators 
	WHERE ClientUserID = @ClientUserID AND ClinicID = @vintClinicID
END  
GO  
