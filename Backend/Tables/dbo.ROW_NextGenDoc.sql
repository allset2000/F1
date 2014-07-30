CREATE TABLE [dbo].[ROW_NextGenDoc]
(
[RuleID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NULL,
[LocationID] [smallint] NULL,
[DictatorName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FieldData] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RuleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROW_NextGenDoc] ADD CONSTRAINT [PK_ROW_NextGenDoc] PRIMARY KEY CLUSTERED  ([RuleID]) ON [PRIMARY]
GO
