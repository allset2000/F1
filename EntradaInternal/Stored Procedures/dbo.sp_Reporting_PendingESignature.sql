SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Charles Arnold
-- Create date: 4/6/2012
-- Description:	Retrieves outstanding jobs 
--		for report "Documents Pending E-Signature.rdl"

-- =============================================
CREATE PROCEDURE [dbo].[sp_Reporting_PendingESignature]

	@PayTypeVar int  --- This parameter was aliased with this name to support portal reporting.
					 --- Value being received is acutally ClinicID.

AS

BEGIN

	SELECT D.LastName + ', ' + D.FirstName AS [Speaker],
		J.DictatorID AS [Speaker ID],
		J.JobNumber,
		J.JobType,
		JP.LastName + ', ' + JP.FirstName AS [Patient],
		JP.MRN,
		J.ReceivedOn,
		J.CompletedOn,
		CAST((CAST(DATEDIFF(HOUR, J.ReceivedOn, GETDATE()) as DECIMAL(10,3)) / CAST(24 as DECIMAL(10,3))) AS DECIMAL(10,3)) as [Days Pending]
	FROM [Entrada].[dbo].[Jobs] J WITH(NOLOCK)
	INNER JOIN [Entrada].[dbo].[Dictators] D WITH(NOLOCK) ON
		J.DictatorID = D.DictatorID
	LEFT OUTER JOIN [Entrada].[dbo].[Jobs_Patients] JP WITH(NOLOCK) ON
		J.JobNumber = JP.JobNumber
	WHERE J.DocumentStatus = 150 AND
		J.ClinicID = CASE @PayTypeVar
						WHEN -1 THEN J.ClinicID
						ELSE @PayTypeVar
					END
	ORDER BY Speaker,
		[Days Pending] desc
	
END	


GO
