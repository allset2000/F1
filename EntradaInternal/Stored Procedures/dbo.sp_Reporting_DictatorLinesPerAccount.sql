SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* ==============================================================
Author:			Jen Blumenthal
Create date:	5/22/13
Description:	Retrieves data for report "Dictator Lines per Account.rdl"

change log:
date		username		description
5/23/13		jablumenthal	per Mike Cardwell parameters MUST be named
							@ReceivedOn, @ReceivedOn2, @PayTypeVar in client
							reports so that they will run in the portal. 
							Renamed my parameters as such.  Also, @PayTypeVar
							must be ClinicID (not ClinicCode as I had it) so I 
							fixed that as well. 
8/8/13		jablumenthal	added ClinicName for report header
================================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_DictatorLinesPerAccount]

	@ReceivedOn DATETIME,	--start date
	@ReceivedOn2 DATETIME,	--end date
	@PayTypeVar varchar(20)	--clinicID

AS
BEGIN


	SELECT	convert(date, J.CompletedOn) as CompletedOn,
			convert(date, J.AppointmentDate) as ApptDate,
			J.DictatorID, 
			JP.MRN,
			J.JobNumber,
			(BJ.DocumentWSpaces / 65.0) as Lines
	FROM Entrada.dbo.Jobs J WITH(NOLOCK) 
	JOIN Entrada.dbo.vwRptBillableJobs BJ WITH (NOLOCK) 
		 on J.JobNumber = BJ.JobNumber
	JOIN Entrada.dbo.Jobs_Patients JP WITH (NOLOCK)
		 on J.JobNumber = JP.JobNumber
	WHERE convert(date, J.CompletedOn) between @ReceivedOn and @ReceivedOn2
	  and J.ClinicID = @PayTypeVar
	ORDER BY J.DictatorID, J.CompletedOn, J.JobNumber			

END

GO
