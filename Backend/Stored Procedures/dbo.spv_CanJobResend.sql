
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Narender
-- Create date: 05-APR-2016
-- Description:	This procedure will get check if a job can be resent from NCP job details view
-- Updated : baswaraj: #5412 - Unlocked jobs(deliverd or editingcompleate #8055) also needs to set to Resend- added document status 130 
-- =============================================
CREATE PROCEDURE [dbo].[spv_CanJobResend]
@Jobnumber varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	
	
	-- Commenting the below implementation to apply same conditions used by OLD portal to enable/disable to Resend Job Delivery
	--SELECT DISTINCT 1 FROM Jobs J	
	--INNER JOIN	dbo.JobDeliveryRules JDR ON J.ClinicID = JDR.ClinicID 
	--LEFT JOIN dbo.JobDeliveryHistory JDH ON J.JobNumber = JDH.JobNumber
	--LEFT JOIN dbo.StatusCodes S on s.StatusID=j.JobStatus
	--LEFT JOIN jobstatusgroup G on G.Id=S.StatusGroupId
	--WHERE ((JDH.JobNumber IS NOT NULL AND (JDR.Method IN (100,300) OR  J.DocumentStatus=130))) OR (s.StatusGroupId=4 AND J.DocumentStatus=130)) 
	--and JDR.AvoidRedelivery = 0 AND J.JobNumber = @Jobnumber  	
	
	DECLARE @CanJobResend INT = 0
	SELECT @CanJobResend = 1 FROM Jobs J
	INNER JOIN dbo.JobDeliveryHistory JDH ON J.JobNumber = JDH.JobNumber
	INNER JOIN	dbo.JobDeliveryRules JDR ON J.ClinicID = JDR.ClinicID AND (JDR.DictatorName = J.DictatorID) AND (JDR.JobType = J.JobType)
	WHERE JDR.Method in (100,300) and AvoidRedelivery = 0 AND J.JobNumber = @Jobnumber
                              
	IF @CanJobResend = 0
	SELECT @CanJobResend = 1 FROM Jobs J
	INNER JOIN dbo.JobDeliveryHistory JDH ON J.JobNumber = JDH.JobNumber
	INNER JOIN	dbo.JobDeliveryRules JDR ON J.ClinicID = JDR.ClinicID AND (JDR.DictatorName = '' OR JDR.DictatorName IS NULL) AND (JDR.JobType = J.JobType)
	WHERE JDR.Method in (100,300) and AvoidRedelivery = 0 AND J.JobNumber = @Jobnumber

	IF @CanJobResend = 0
	SELECT @CanJobResend = 1 FROM Jobs J
	INNER JOIN dbo.JobDeliveryHistory JDH ON J.JobNumber = JDH.JobNumber
	INNER JOIN	dbo.JobDeliveryRules JDR ON J.ClinicID = JDR.ClinicID AND (JDR.DictatorName = J.DictatorID )AND (JDR.JobType = '' OR JDR.JobType IS NULL)
	WHERE JDR.Method in (100,300) and AvoidRedelivery = 0 AND J.JobNumber = @Jobnumber


	IF @CanJobResend = 0
	SELECT @CanJobResend = 1 FROM Jobs J
	INNER JOIN dbo.JobDeliveryHistory JDH ON J.JobNumber = JDH.JobNumber
	INNER JOIN	dbo.JobDeliveryRules JDR ON J.ClinicID = JDR.ClinicID AND (JDR.DictatorName = '' OR JDR.DictatorName IS NULL) AND (JDR.JobType = '' OR JDR.JobType IS NULL)
	WHERE JDR.Method in (100,300) and AvoidRedelivery = 0 AND J.JobNumber = @Jobnumber

	SELECT @CanJobResend

END
GO
