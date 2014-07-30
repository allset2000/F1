SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeBillItem] (
    @BillItemId  [int],
	@BillId  [int],
	@BillingRuleId  [int],
	@ProviderId  [int],
	@JobId  [int],
	@Description  [varchar]  (255),
	@BillItemDate  [smalldatetime],
	@UnitPrice  [decimal](9,4),
	@Qty  [decimal](9,6),
	@SubTotal  [decimal](9,2),
	@Tax  [decimal] (9,2)
) AS 
IF NOT EXISTS(SELECT 1 FROM [dbo].[BillItems] WHERE ([BillItemId] = @BillItemId))
	 BEGIN
		INSERT INTO [dbo].[BillItems] (
			[BillItemId], [BillId],	[BillingRuleId], [ProviderId], [JobId], [Description],
			[BillItemDate], [UnitPrice], [Qty], [SubTotal], [Tax]
		) VALUES (
			@BillItemId, @BillId, @BillingRuleId, @ProviderId, @JobId, @Description,
			@BillItemDate, @UnitPrice, @Qty, @SubTotal, @Tax
		)
	 END
ELSE 
	 BEGIN
		UPDATE [dbo].[BillItems] 
		 SET
			 [BillId] = @BillId ,
			 [BillingRuleId] = @BillingRuleId ,
			 [ProviderId] = @ProviderId ,
			 [JobId] = @JobId ,
			 [Description] = @Description ,
			 [BillItemDate] = @BillItemDate ,
			 [UnitPrice] = @UnitPrice ,
			 [Qty] = @Qty ,
			 [SubTotal] = @SubTotal ,
			 [Tax] = @Tax
		WHERE 
			([BillItemId] = @BillItemId)
	END
GO
