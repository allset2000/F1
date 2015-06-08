/******************************  
** File:  spGetEncounter.sql  
** Name:  spGetEncounter  
** Desc:  Get Encounter details based on encounter id 
** Auth:  Suresh  
** Date:  18/May/2015  
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**   
*******************************/  
CREATE PROCEDURE [dbo].[spGetEncounter]   
(    
 @vintEncounterID BIGINT  
)    
AS    
BEGIN   
 SELECT EncounterID,  
  AppointmentDate,  
  PatientID,  
  ScheduleID  
  FROM Encounters WHERE EncounterID = @vintEncounterID  
END
GO