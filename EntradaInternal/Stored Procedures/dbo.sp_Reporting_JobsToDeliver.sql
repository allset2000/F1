SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 4/6/2012
-- Description:	Retrieves outstanding jobs 
--		for report "Jobs to Deliver.rdl"

-- =============================================
create PROCEDURE [dbo].[sp_Reporting_JobsToDeliver]

	@ClinicNameList varchar(200)

AS

BEGIN

	SELECT JTD.JobNumber, 
		JTD.Method, 
		JTD.RuleName, 
		JTD.ClinicName, 
		JTD.DictatorID, 
		JTD.AppointmentDate, 
		JTD.AppointmentTime, 
		JTD.JobType, 
		JTD.MRN, 
		JTD.FirstName, 
		JTD.LastName,
		JC.Custom1 AS [Attending ID],
		JP.AlternateID AS [Alternate ID],
		JC.Custom6 AS [Appt ID]
	FROM [Entrada].[dbo].qryJobsToDeliver JTD WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].Jobs_Custom JC WITH(NOLOCK) ON 
		JTD.JobNumber = JC.JobNumber
	LEFT OUTER JOIN [Entrada].[dbo].Jobs_Patients JP WITH(NOLOCK) ON
		JTD.JobNumber = JP.JobNumber
	WHERE (ClinicName = @ClinicNameList)
	
END	


GO
