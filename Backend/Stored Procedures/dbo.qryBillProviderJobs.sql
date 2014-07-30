SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[qryBillProviderJobs] (
   @BillId int
)
AS
SELECT     dbo.BillItems.BillId, dbo.BillItems.ProviderId, ISNULL(dbo.Dictators.ProviderType, 'Default') AS ProviderType, COUNT(dbo.vwJobsForBilling.JobId) AS JobsCount, 
                      SUM(CASE Stat WHEN 1 THEN 1 ELSE 0 END) AS StatJobsCount, SUM(dbo.BillItems.Qty) AS LinesCount
FROM         dbo.vwJobsForBilling INNER JOIN
                      dbo.Dictators ON dbo.vwJobsForBilling.DictatorIdOk = dbo.Dictators.DictatorIdOk INNER JOIN
                      dbo.BillItems INNER JOIN
                      dbo.BillingRules ON dbo.BillItems.BillingRuleId = dbo.BillingRules.BillingRuleId INNER JOIN
                      dbo.BillingConcepts ON dbo.BillingRules.BillingConceptId = dbo.BillingConcepts.BillingConceptId ON dbo.Dictators.DictatorIdOk = dbo.BillItems.ProviderId INNER JOIN
                      dbo.Bills ON dbo.BillItems.BillId = dbo.Bills.BillId AND dbo.vwJobsForBilling.CompletedOn >= dbo.Bills.PeriodStart AND 
                      dbo.vwJobsForBilling.CompletedOn <= dbo.Bills.PeriodEnd
WHERE     (dbo.BillingConcepts.CalculationSource = 'Jobs') AND dbo.BillItems.BillId = @BillId
GROUP BY dbo.BillItems.BillId, dbo.BillItems.ProviderId, dbo.Dictators.ProviderType
RETURN
GO
