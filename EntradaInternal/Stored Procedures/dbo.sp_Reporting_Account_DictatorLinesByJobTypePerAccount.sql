SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/* ==============================================================
Author:			Jen Blumenthal
Create date:	9/11/13
Description:	Retrieves data for report "Dictator Lines by Job Type per Account.rdl"

change log:
date		username		description
1/21/14		jablumenthal	added ClinicName to the query and the ability to select 'all' clinics in report. 
1/6/15		ddorsey			recreated original to run for a specific account
================================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_Account_DictatorLinesByJobTypePerAccount]

	@ReceivedOn DATETIME,	--start date
	@ReceivedOn2 DATETIME,	--end date
	@PayTypeVar varchar(max)	--clinicID

AS
BEGIN

/* for testing:
set @ReceivedOn = GETDATE() - 2
set @ReceivedOn2 = getdate()
set @Paytypevar = '2,8,9,12,15,18,21,47'
*/

	SELECT	convert(date, J.CompletedOn) as CompletedOn,
			convert(date, J.AppointmentDate) as ApptDate,
			J.DictatorID, 
			J.JobType,
			JP.MRN,
			J.JobNumber,
			(BJ.DocumentWSpaces / 65.0) as Lines, 
			C.ClinicName
	FROM Entrada.dbo.Jobs J WITH(NOLOCK) 
	JOIN Entrada.dbo.vwRptBillableJobs BJ WITH (NOLOCK) 
		 on J.JobNumber = BJ.JobNumber
	JOIN Entrada.dbo.Jobs_Patients JP WITH (NOLOCK)
		 on J.JobNumber = JP.JobNumber
	JOIN Entrada.dbo.Clinics C WITH (NOLOCK)
		 on J.ClinicID = C.ClinicID
	WHERE convert(date, J.CompletedOn) between @ReceivedOn and @ReceivedOn2
	  and C.ClinicCode = @PayTypeVar
	  --and J.ClinicID in (select ltrim(rtrim(ClinicID)) from #Clinics)
	ORDER BY J.DictatorID, J.CompletedOn, J.JobNumber			

END



GO
