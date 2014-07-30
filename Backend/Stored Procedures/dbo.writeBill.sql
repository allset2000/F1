SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[writeBill] (
	@BillId  [int],
	@ClinicId  [int],
	@ProviderId  [int],
	@SendToEMail  [varchar]  (64),
	@SalesTerm  [varchar]  (64),
	@PeriodStart  [smalldatetime],
	@PeriodEnd  [smalldatetime],
	@IssueDate  [smalldatetime],
	@DueDate  [smalldatetime],
	@BillStatus  [char]  (1) 
) AS 
IF NOT EXISTS(SELECT 1 FROM [dbo].[Bills] WHERE ([BillId] = @BillId))
	 BEGIN
		INSERT INTO [dbo].[Bills] (
			[BillId], [ClinicId], [ProviderId], [SendToEMail], [SalesTerm],
			[PeriodStart], [PeriodEnd], [IssueDate], [DueDate], [BillStatus] 
		) VALUES (
			@BillId, @ClinicId, @ProviderId, @SendToEMail, @SalesTerm,
			@PeriodStart, @PeriodEnd, @IssueDate, @DueDate, @BillStatus
		)
	 END
ELSE 
	 BEGIN
		UPDATE [dbo].[Bills] 
		 SET
			 [ClinicId] = @ClinicId ,
			 [ProviderId] = @ProviderId ,
			 [SendToEMail] = @SendToEMail ,
			 [SalesTerm] = @SalesTerm ,
			 [PeriodStart] = @PeriodStart ,
			 [PeriodEnd] = @PeriodEnd ,
			 [IssueDate] = @IssueDate ,
			 [DueDate] = @DueDate ,
			 [BillStatus] = @BillStatus  
		WHERE 
			([BillId] = @BillId) 

	END
GO
