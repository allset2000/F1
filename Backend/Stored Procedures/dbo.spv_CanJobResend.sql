
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Narender
-- Create date: 05-APR-2016
-- Description:	This procedure will get check if a job can be resent from NCP job details view
-- =============================================
CREATE PROCEDURE [dbo].[spv_CanJobResend]
@Jobnumber varchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT DISTINCT 1 FROM Jobs J
	INNER JOIN dbo.JobDeliveryHistory JDH ON J.JobNumber = JDH.JobNumber
	INNER JOIN	dbo.JobDeliveryRules JDR ON J.ClinicID = JDR.ClinicID
	WHERE JDR.Method in (100,300) and AvoidRedelivery = 0 AND J.JobNumber = @Jobnumber
END

GO
