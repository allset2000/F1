SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/******************************  
** File:  spv_GetJobsToDeliver.sql  
** Name:  spv_GetJobsToDeliver  
** Desc:  Get Jobs to Deliver
** Auth:  Suresh  
** Date:  20/May/2016  
** EXEC spv_GetJobsToDeliver 356,900,30
**************************  
** Change History  
**************************  
** PR   Date     Author  Description   
** --   --------   -------   ------------------------------------  
**  
*******************************/  
CREATE PROCEDURE [dbo].[spv_GetJobsToDeliver]   
(    
 @vintClinicID INT,
 @vintMethod INT,
 @vintRowRetryDuration INT
)    
AS    
BEGIN   
	SELECT JobsToDeliver.DeliveryID, Jobs.JobNumber, JobType, Jobs.DictatorID, AppointmentDate, AppointmentTime, MRN, AlternateID, FirstName, LastName, 
	FileName AS ClientJobNumber, ParentJobNumber, RuleName 
	FROM JobsToDeliver
	INNER JOIN Jobs 
		ON JobsToDeliver.JobNumber = Jobs.JobNumber
	INNER JOIN Jobs_Patients 
		ON JobsToDeliver.JobNumber = Jobs_Patients.JobNumber
	INNER JOIN Jobs_Client 
		ON JobsToDeliver.JobNumber = Jobs_Client.JobNumber
	LEFT OUTER JOIN ( SELECT DeliveryID, MAX(ErrorDate) ErrorDate FROM JobsToDeliverErrors GROUP BY DeliveryID ) jde 
		ON JobsToDeliver.DeliveryID= jde.DeliveryID
	WHERE ClinicID = @vintClinicID AND JobsToDeliver.Method = @vintMethod 
		AND (jde.ErrorDate IS NULL OR (jde.ErrorDate IS NOT NULL AND DATEDIFF(MINUTE, jde.ErrorDate, GETDATE()) > @vintRowRetryDuration))
END
GO
