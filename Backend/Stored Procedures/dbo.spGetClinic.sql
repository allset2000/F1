/******************************  
** File:  spGetClinic.sql  
** Name:  spGetClinic  
** Desc:  Get Clinic information based on clinic id  
** Auth:  Suresh  
** Date:  12/Feb/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
CREATE PROCEDURE [dbo].[spGetClinic]  
(  
 @vintClinicId int  
)  
AS  
BEGIN  
 SELECT  ClinicID,  
   ClinicName,  
   ClinicCode,  
   SreTypeId  
 FROM Clinics  
 WHERE clinicID = @vintClinicId  
  
END  