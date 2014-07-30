SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/* =======================================================
Author:			Jen Blumenthal
Create date:	7/15/13
Description:	Retrieves dictator roster for a specific date range
				and clinic. 
				
change log

date		username		description
======================================================= */
CREATE PROCEDURE [dbo].[sp_Reporting_DictatorRoster_new]
--declare 
	@ReceivedOn datetime,
	@ReceivedOn2 datetime,
	@PayTypeVar varchar(5)

--set @ReceivedOn = getdate() - 10
--set @ReceivedOn2 = getdate()
--set @PayTypeVar = 'VOI'

AS
BEGIN

	SELECT Distinct 
		D.ClinicID,
		C.ClinicName,
		D.FirstName,
		D.MI,
		D.LastName,
		D.DictatorID,
		D.[Signature] AS [Credentials],
		V.EpicId
	FROM [Entrada].[dbo].[Jobs] J with (nolock)
	JOIN [Entrada].[dbo].[Dictators] D with (nolock) ON J.DictatorID = D.DictatorID
	JOIN [Entrada].[dbo].[Clinics] C with (nolock) ON J.ClinicID = C.ClinicID
	LEFT OUTER JOIN [EntradaInternal].[dbo].[VanderbiltEpicIds] V with (nolock) ON J.DictatorID = V.DictatorId
	WHERE C.ClinicCode = @PayTypeVar
	  AND convert(date, J.ReceivedOn) between convert(date, @ReceivedOn) and convert(date, @ReceivedOn2)

END
GO
