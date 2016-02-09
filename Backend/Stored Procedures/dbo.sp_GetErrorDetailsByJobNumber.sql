SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Author: Baswaraj.K
/******* This is used to get Latest Error Information(Jobnumber,ErrorDate,ResolutionGuide,FileName,EHREncounterId,AppointmentId) by jobnumber ******/
--exec sp_GetErrorDetailsByJobNumber '2016020400000019'
CREATE PROCEDURE [dbo].[sp_GetErrorDetailsByJobNumber]
(
	@jobNumber varchar(1000)
)
AS
BEGIN	
				SELECT B.Jobnumber,B.ErrorDate,ED.ResolutionGuide,JC.FileName,S.EHREncounterId,S.AppointmentId  
                FROM
				(
					 SELECT TOP 1 JOBNUMBER,ErrorCode ,ErrorDate
					 FROM
						(
							SELECT J.JOBNUMBER,J2DE.ErrorCode AS ErrorCode,MAX(J2DE.ErrorDate) AS ErrorDate
							FROM jobstodeliver J2D 
							    INNER JOIN JOBS J ON j.jobnumber=j2d.jobnumber
								INNER JOIN JobsToDeliverErrors J2DE ON J2D.DeliveryID = J2DE.DeliveryID
								INNER JOIN EntradaHostedClient.DBO.ErrorDefinitions ED ON ED.ErrorCode=J2DE.ErrorCode	
								INNER JOIN EntradaHostedClient.DBO.ErrorSourceTypes EST ON EST.ErrorSourceTypeID=ED.ErrorSourceType													
							WHERE J.JobNumber=@jobNumber AND EST.ErrorSourceTypeID=1 -- CLIENT-DELIVERY ERRORs Only
							GROUP BY J.JOBNUMBER,J2DE.ErrorCode
						UNION --ALL
							SELECT J.JOBNUMBER AS JOBNUMBER,EHJDE.ErrorCode AS ErrorCode,MAX(EHJDE.ChangedOn) AS ErrorDate
							FROM jobs J 
								INNER JOIN jobs_client JC ON J.jobnumber=JC.jobnumber
								INNER JOIN eh_jobs EHJ ON EHJ.jobnumber=JC.[FILENAME] 
								INNER JOIN eh_jobsdeliveryerrors EHJDE ON EHJDE.jobid=EHJ.jobid 
								INNER JOIN EntradaHostedClient.DBO.ErrorDefinitions ED ON ED.ErrorCode=EHJDE.ErrorCode
								INNER JOIN EntradaHostedClient.DBO.ErrorSourceTypes EST ON EST.ErrorSourceTypeID=ED.ErrorSourceType													
							WHERE J.JobNumber=@jobNumber AND EST.ErrorSourceTypeID=1 -- CLIENT-DELIVERY ERRORs Only
							GROUP BY J.JOBNUMBER,EHJDE.ErrorCode
						 ) A ORDER BY ErrorDate DESC				 
				) B
				INNER JOIN EntradaHostedClient.DBO.ErrorDefinitions ED ON ED.ErrorCode=B.ErrorCode	
				INNER JOIN Jobs_Client JC on JC.jobnumber=B.jobnumber
				INNER JOIN Eh_Jobs EHJ on EHJ.jobnumber=JC.FileName
				LEFT OUTER JOIN EH_Encounters E on E.EncounterId = EHJ.EncounterId 
				LEFT OUTER JOIN EH_Schedules S on S.SCheduleId = E.ScheduleId 
				WHERE EHJ.JobNumber = JC.FileName
				
END

GO
