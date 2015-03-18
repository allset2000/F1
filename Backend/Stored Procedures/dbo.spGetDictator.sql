/******************************  
** File:  spGetDictator.sql  
** Name:  spGetDictator  
** Desc:  get dectator details based on dictator id  
** Auth:  Suresh  
** Date:  12/Feb/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
CREATE PROCEDURE [dbo].[spGetDictator]  
(  
 @vnvcrDictatorID NVARCHAR(20)  
)  
AS  
BEGIN  
 SELECT  DictatorID,  
   ClinicID,  
   ClientUserID,  
   FIrstName,  
   lastName,  
   Vrenabled,  
   SreTypeId  
 FROM Dictators  
 WHERE DictatorID = @vnvcrDictatorID  
  
END  