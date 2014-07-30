CREATE TABLE [dbo].[ClinicsMessages]
(
[MessageId] [int] NOT NULL,
[MessageRuleId] [int] NOT NULL,
[MessageSubject] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MessageBody] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PostingTime] [smalldatetime] NOT NULL,
[ProgrammedTime] [smalldatetime] NOT NULL,
[SendTime] [smalldatetime] NOT NULL,
[HighPriority] [bit] NOT NULL,
[ParentMessageId] [int] NOT NULL,
[MessageStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClinicsMessages] ADD CONSTRAINT [PK_ClinicsMessages] PRIMARY KEY CLUSTERED  ([MessageId]) ON [PRIMARY]
GO
