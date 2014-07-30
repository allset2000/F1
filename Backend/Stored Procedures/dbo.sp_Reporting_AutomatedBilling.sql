SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[sp_Reporting_AutomatedBilling]

AS
BEGIN

SET NOCOUNT ON;

	
		Select  
		bi.[BillItemId]
		,bi.[JobId]
		,bi.[Description]
		,bi.[BillItemDate]
		,bi.[UnitPrice]
		,bi.[Qty]
		,bi.[SubTotal]
		,bi.[Tax]
		,br.BillingRuleId
		,b.[BillId]
		,b.[ClinicId]
		,b.[ProviderId]
		,b.[SalesTerm]
		,b.[PeriodStart]
		,b.[PeriodEnd]
		,b.[IssueDate]
		,b.[DueDate]
		,b.[BillStatus]
		,b.SendToEmail
		,c.ClinicName
		,c.ClinicCode
		,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)) AS TxnDate
		,'N' as Printed
		,'Y' as Emailed
		,'N' as Taxable

From BillItems bi
JOIN BillingRules br ON br.BillingRuleId = bi.BillingRuleId
JOIN Bills b ON bi.BillId = b.BillId
JOIN Clinics c ON c.ClinicID= b.ClinicId
		
END
GO
