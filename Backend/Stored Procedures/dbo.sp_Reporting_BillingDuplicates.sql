SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* =======================================================
Author:			Charles Arnold
Create date:	1/27/2012
Description:	Retrieves editor production data
				for report "Billing Duplicates.rdl"
				
change log

date		username		description
4/12/13		jablumenthal	updated stored proc to use new tables.
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_BillingDuplicates] 

@BeginDate datetime


AS
BEGIN

	SELECT  C.ClinicName,
			J.[DictatorID],
			J.JobNumber,
			JP.[MRN],
			JP.LastName + ', ' + JP.FirstName AS [Patient],
			J.ContextName,
			J.[Duration],
			J.AppointmentDate,
			J.[DictationDate],
			DS.[Description] AS [Status],
			EJ.NumVBC as [Chars],
			(CAST(EJ.NumVBC as DECIMAL(10, 2)) / 65) as [Lines]
			/*
			JED.NumVBC_Editor AS [Chars],
			(CAST(JED.NumVBC_Editor AS DECIMAL(10, 2)) / 65) as [Lines]
			*/
	FROM [Entrada].[dbo].[Jobs] J INNER JOIN
	(
		SELECT  COUNT(*) AS [Count],
				J.DictatorID,
				JP.MRN,
				J.ContextName,
				J.Duration,
				J.AppointmentDate,
				J.AppointmentTime
		FROM [Entrada].[dbo].JOBS J WITH(NOLOCK)
		left outer JOIN [Entrada].[dbo].Jobs_Patients JP WITH(NOLOCK) ON
			 J.JobNumber = JP.JobNumber
		JOIN [Entrada].dbo.vwRptEditingJobs EJ2 WITH (NOLOCK) ON
			 J.JobNumber = EJ2.JobNumber
		--LEFT OUTER JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON  	--- LEFT OUTER will include Chars = NULL; INNER JOIN will eliminate these
		--	 J.JobNumber = JED.JobNumber
		WHERE ReceivedOn > @BeginDate 
		  AND ParentJobNumber IS NULL
		GROUP BY J.DictatorID,
				JP.MRN,
				J.ContextName,
				J.Duration,
				J.AppointmentDate,
				J.AppointmentTime
		HAVING COUNT(*) > 1
	) T ON
		J.DictatorID=T.DictatorID AND 
		J.AppointmentDate=T.AppointmentDate AND 
		J.AppointmentTime=T.AppointmentTime AND 
		J.Duration=T.Duration AND 
		J.ContextName=T.ContextName
	INNER JOIN [Entrada].[dbo].Jobs_Patients JP WITH(NOLOCK) ON 
		J.JobNumber=JP.JobNumber AND 
		JP.MRN=T.MRN
	LEFT OUTER JOIN [Entrada].[dbo].DocumentStatus DS WITH(NOLOCK) ON
		J.DocumentStatus = DS.DocStatus	
	JOIN [Entrada].dbo.vwRptEditingJobs EJ WITH (NOLOCK) ON
		 J.JobNumber = EJ.JobNumber
	--LEFT OUTER JOIN [Entrada].[dbo].Jobs_EditingData JED WITH(NOLOCK) ON
	--	J.JobNumber = JED.JobNumber 
	INNER JOIN [Entrada].[dbo].[Clinics] C WITH(NOLOCK) ON 
		J.ClinicID = C.ClinicID
	ORDER BY J.DictatorID,
			Patient,
			ContextName
				
END
GO
