SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[writeClinicMessage] (
	@MessageId  [int],
	@MessageRuleId  [int],
	@MessageSubject  [varchar]  (255),
	@MessageBody  [text],
	@PostingTime  [smalldatetime],
	@ProgrammedTime  [smalldatetime],
	@SendTime  [smalldatetime],
	@HighPriority [bit],
	@ParentMessageId  [int],
	@MessageStatus  [char]  (1) 
) AS 
IF NOT EXISTS(SELECT * FROM [dbo].[ClinicsMessages] WHERE ([MessageId] = @MessageId))
   BEGIN
		INSERT INTO [dbo].[ClinicsMessages] (
			[MessageId], [MessageRuleId], [MessageSubject], [MessageBody], [PostingTime], 
			[ProgrammedTime], [SendTime], [HighPriority], [ParentMessageId], [MessageStatus] 
	) VALUES (
			@MessageId, @MessageRuleId, @MessageSubject, @MessageBody, @PostingTime, 
			@ProgrammedTime, @SendTime, @HighPriority, @ParentMessageId, @MessageStatus 
   )
   END
ELSE 
   BEGIN
			UPDATE [dbo].[ClinicsMessages] 
			 SET
				 [MessageRuleId] = @MessageRuleId ,
				 [MessageSubject] = @MessageSubject ,
				 [MessageBody] = @MessageBody ,
				 [PostingTime] = @PostingTime ,
				 [ProgrammedTime] = @ProgrammedTime ,
				 [SendTime] = @SendTime ,
				 [HighPriority] = @HighPriority, 
				 [ParentMessageId] = @ParentMessageId ,
				 [MessageStatus] = @MessageStatus  
			WHERE 
				([MessageId] = @MessageId) 
END
GO
