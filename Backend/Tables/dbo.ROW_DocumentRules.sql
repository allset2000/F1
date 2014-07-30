CREATE TABLE [dbo].[ROW_DocumentRules]
(
[RuleID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ClinicID] [smallint] NULL,
[LocationID] [smallint] NULL,
[DictatorName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RenamingRule] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RuleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROW_DocumentRules] ADD CONSTRAINT [PK_ROW_DocumentRules] PRIMARY KEY CLUSTERED  ([RuleID]) ON [PRIMARY]
GO
