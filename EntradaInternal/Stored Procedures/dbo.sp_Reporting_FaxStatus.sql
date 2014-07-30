SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 5/9/2012
-- Description:	Retrieves job fax statuses for  
--		for report "Fax Status.rdl"

-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_FaxStatus]

	@ReceivedOn datetime,
	@ReceivedOn2 datetime,
	@PayTypeVar int --- This is actually the ClinicID
	
AS

BEGIN

	SELECT J.JobNumber AS [Job Number],
		 J.JobType AS [Job Type],
		 [Status] = CASE 
						WHEN DJE.deliveryStatus IS NULL THEN CASE 
																WHEN JSA.[Status] IS NULL THEN 'FAX Status'
																ELSE SC.StatusName
															END
						ELSE 'FAX Status'
					END,
		 JP.MRN,
		 JP.LastName + ', ' + JP.FirstName AS [Patient Name],
		 J.AppointmentDate,
		 J.CompletedOn,
		 DJE.disposed AS [Faxed],
		 D.attentionTo AS [Recipient],
		 D.destinationData AS [Recipient Number],
		 DJE.deliveryStatus AS [Successful Fax]	 
	FROM [Entrada].[dbo].[Jobs] J WITH(NOLOCK)
	LEFT OUTER JOIN [Entrada].[dbo].[JobStatusA] JSA WITH(NOLOCK) ON
		J.JobNumber = JSA.JobNumber	
	LEFT OUTER JOIN [Entrada].[dbo].[StatusCodes] SC WITH(NOLOCK) ON
		JSA.[Status] = SC.StatusID
	LEFT OUTER JOIN [EntradaFax].[dbo].[faxJobQueue] JQ WITH(NOLOCK) ON
		J.JobNumber = JQ.entradaJobNum
	LEFT OUTER JOIN [EntradaFax].[dbo].[faxDestinatinonJobEvents] DJE WITH(NOLOCK) ON
		JQ.id = DJE.faxJobQueueId
	LEFT OUTER JOIN [EntradaFax].[dbo].[faxDestinations] D WITH(NOLOCK) ON
		DJE.faxDestinationId = D.id
	INNER JOIN [Entrada].[dbo].[Jobs_Patients] JP WITH(NOLOCK) ON
		J.JobNumber = JP.JobNumber
	WHERE --DJE.disposed BETWEEN DATEADD(DAY, -7, GETDATE()) AND GETDATE() AND
		J.AppointmentDate BETWEEN DATEADD(dd, DATEDIFF(dd, 0, @ReceivedOn)+0, 0)  AND DATEADD(S, -1, DATEADD(dd, DATEDIFF(dd, 0, @ReceivedOn2)+1, 0))   AND
		J.ClinicID = @PayTypeVar AND
		J.JobType = 'Work Comp Note'
	order by JP.LastName,
		JP.FirstName,
		DJE.created

	
END	


GO
