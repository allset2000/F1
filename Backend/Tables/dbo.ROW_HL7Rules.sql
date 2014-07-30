CREATE TABLE [dbo].[ROW_HL7Rules]
(
[RuleID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NULL,
[LocationID] [smallint] NULL,
[DictatorName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Message] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FieldData] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RuleName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROW_HL7Rules] ADD CONSTRAINT [PK_ROW_HL7Rules] PRIMARY KEY CLUSTERED  ([RuleID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Data Dictionary', 'SCHEMA', N'dbo', 'TABLE', N'ROW_HL7Rules', 'COLUMN', N'FieldData'
GO
EXEC sp_addextendedproperty N'MS_Description', N'HL7 Message', 'SCHEMA', N'dbo', 'TABLE', N'ROW_HL7Rules', 'COLUMN', N'Message'
GO
