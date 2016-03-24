
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- Author: Baswaraj.K
/******* This is used to get Latest Error Information(Jobnumber,ErrorDate,ResolutionGuide,FileName,EHREncounterId,AppointmentId) by jobnumber ******/
--exec sp_GetErrorDetailsByJobNumber '2016012000000004'
-- Tickey# 7110, Sharif Sharif added ISNULL(J2DE.Message, J2DE.ErrorMessage), date: March 24, 2016

CREATE PROCEDURE [dbo].[sp_GetErrorDetailsByJobNumber]
(
	@jobNumber varchar(1000)
)
AS
BEGIN	


DECLARE @ActualCount int 
DECLARE @FilledCount int
DECLARE @VendorId INT
        -- Get vendorID for the job
		SELECT TOP 1 @VendorId=C.EHRVendorId 
		FROM Jobs J 
		            INNER JOIN EH_Clinics C on C.ClinicId = J.ClinicId 
		WHERE J.JobNumber = @jobNumber
		--Get How Many Override values Added already
		SELECT @FilledCount=Count(DISTINCT rov.FieldID) 
		FROM EH_ROWOverrideValues rov 
		INNER JOIN EH_ROWOverrideFields rof ON rof.FieldID = rov.FieldID 
		WHERE JobNumber=@jobNumber
		-- Get how many field we have for to override the value
		SELECT @ActualCount=Count(DISTINCT FieldID) 
		FROM EH_ROWOverrideFields 
		WHERE EHRVendorId=@VendorId

		
				SELECT B.Jobnumber, B.ErrorDate, ED.ResolutionGuide,B.ErrorMessage,JC.FileName, S.EHREncounterId, S.AppointmentId, 
				    CASE WHEN @ActualCount=@FilledCount THEN 0 ELSE 1 END  AS 'ADDOverrideStatus' -- if all override fields are added than 0 else 1
                FROM
				(
					 SELECT TOP 1 JOBNUMBER,ErrorCode ,ErrorDate,ErrorMessage
					 FROM
						(
							SELECT J.JOBNUMBER,J2DE.ErrorCode AS ErrorCode,ISNULL(J2DE.Message, J2DE.ErrorMessage) AS ErrorMessage,MAX(J2DE.ErrorDate) AS ErrorDate
							FROM jobstodeliver J2D 
							    INNER JOIN JOBS J ON j.jobnumber=j2d.jobnumber
								INNER JOIN JobsToDeliverErrors J2DE ON J2D.DeliveryID = J2DE.DeliveryID
								INNER JOIN EntradaHostedClient.DBO.ErrorDefinitions ED ON ED.ErrorCode=J2DE.ErrorCode	
								INNER JOIN EntradaHostedClient.DBO.ErrorSourceTypes EST ON EST.ErrorSourceTypeID=ED.ErrorSourceType													
							WHERE J.JobNumber=@jobNumber AND EST.ErrorSourceTypeID=1 -- CLIENT-DELIVERY ERRORs Only
							GROUP BY J.JOBNUMBER,J2DE.ErrorCode,ISNULL(J2DE.Message, J2DE.ErrorMessage)
						UNION --ALL
							SELECT J.JOBNUMBER AS JOBNUMBER,EHJDE.ErrorCode AS ErrorCode,EHJDE.ErrorMessage AS ErrorMessage,MAX(EHJDE.ChangedOn) AS ErrorDate
							FROM jobs J 
								INNER JOIN jobs_client JC ON J.jobnumber=JC.jobnumber
								INNER JOIN eh_jobs EHJ ON EHJ.jobnumber=JC.[FILENAME] 
								INNER JOIN eh_jobsdeliveryerrors EHJDE ON EHJDE.jobid=EHJ.jobid 
								INNER JOIN EntradaHostedClient.DBO.ErrorDefinitions ED ON ED.ErrorCode=EHJDE.ErrorCode
								INNER JOIN EntradaHostedClient.DBO.ErrorSourceTypes EST ON EST.ErrorSourceTypeID=ED.ErrorSourceType													
							WHERE J.JobNumber=@jobNumber AND EST.ErrorSourceTypeID=1 -- CLIENT-DELIVERY ERRORs Only
							GROUP BY J.JOBNUMBER,EHJDE.ErrorCode,EHJDE.ErrorMessage
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

