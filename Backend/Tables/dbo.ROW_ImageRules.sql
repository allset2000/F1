CREATE TABLE [dbo].[ROW_ImageRules]
(
[RuleID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ClinicID] [smallint] NULL,
[LocationID] [smallint] NULL,
[DictatorName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RenamingRule] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RuleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
ALTER TABLE [dbo].[ROW_ImageRules] ADD 
CONSTRAINT [PK_ROW_ImageRules] PRIMARY KEY CLUSTERED  ([RuleID]) ON [PRIMARY]
GO
