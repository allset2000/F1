SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_Reporting_VandyDictatorRoster]
@ReceivedOn varchar(3) =null,
@ReceivedOn2 varchar(3)= null,
@PayTypeVar varchar(3)=null
AS

BEGIN

	SELECT D.ClinicID,
		C.ClinicName,
		D.FirstName,
		D.MI,
		D.LastName,
		D.DictatorID,
		D.[Signature] AS [Credentials],
		V.EpicId
	FROM [Entrada].[dbo].[Dictators] D
	INNER JOIN [Entrada].[dbo].[Clinics] C ON
		D.ClinicID = C.ClinicID
	LEFT OUTER JOIN [EntradaInternal].[dbo].[VanderbiltEpicIds] V ON
		D.DictatorID = V.DictatorId
	WHERE D.ClinicID = 2 OR
		D.ClinicID = 54

END
GO
