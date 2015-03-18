/******************************  
** File:  spInsertStat.sql  
** Name:  spInsertStat  
** Desc:  add the record into Stats table  
** Auth:  Suresh  
** Date:  13/Feb/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
CREATE PROCEDURE [dbo].[spInsertStat]  
(  
 @vvcrJob  VARCHAR(50),  
 @vdtmStartTime DATETIME,  
 @vdtmEndTIme DATETIME,  
 @vsmintNumChars SMALLINT,  
 @vvcrDictator VARCHAR(100),  
 @vvcrTopic  VARCHAR(100),  
 @vfltConfidence FLOAT  
)  
AS  
BEGIN  
 INSERT   
 INTO Stats(Job,JobDate,StartTime,EndTime,NumChars,Dictator,Topic,Confidence)  
 VALUES (@vvcrJob,GETDATE(),@vdtmStartTime,@vdtmEndTIme,@vsmintNumChars,@vvcrDictator,@vvcrTopic,@vfltConfidence)  
  
END  