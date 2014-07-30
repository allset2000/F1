SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- ============================================================
-- Author:		Jen Blumenthal
-- Create date: 2/19/2013
-- Description:	Provides a list by physician of all jobs pending 
--				e-signature by date of delivery.
--
-- ============================================================

CREATE PROCEDURE [dbo].[sp_Reporting_JobsPendingESignature]

	@PayTypeVar varchar(20) -- ClinicCode

AS
BEGIN

SET NOCOUNT ON
SET CONCAT_NULL_YIELDS_NULL OFF

--declare @paytypevar varchar(20) --for testing
--set @PayTypeVar = 'VEZ'

	SELECT  J.JobNumber, 
			coalesce(D.[signature], D.FirstName + ' ' + D.LastName + D.Suffix) as DictatorName,
			JDH.DeliveredOn,
			DATEDIFF(dd,JDH.DeliveredOn, getdate()) as Days_delivered
	FROM Entrada.dbo.Jobs J
	JOIN Entrada.dbo.DocumentStatus DS with (nolock)
		 ON J.DocumentStatus = DS.DocStatus
	JOIN Entrada.dbo.JobDeliveryHistory JDH with (nolock)
		 ON J.JobNumber = JDH.JobNumber
	JOIN Entrada.dbo.Clinics C
		 on J.ClinicID = C.ClinicID
	JOIN Entrada.dbo.Dictators D
		 ON J.DictatorID = D.DictatorID
	WHERE C.ClinicCode = @PayTypeVar
	  AND J.DocumentStatus = 150 --'Document Pending e-Signature'
	ORDER BY coalesce(D.[signature], D.FirstName + ' ' + D.LastName + D.Suffix),
			 JDH.DeliveredOn

END




GO
