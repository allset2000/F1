CREATE TABLE [dbo].[ROWTemplates]
(
[ROWTemplateId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Template] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SplitMessageByTags] [bit] NULL CONSTRAINT [DF_ROWTemplates_SplitMessageByTags] DEFAULT ((0)),
[Deleted] [bit] NULL CONSTRAINT [DF__ROWTempla__Delet__161C9784] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROWTemplates] ADD CONSTRAINT [PK_ROWTemplates] PRIMARY KEY CLUSTERED  ([ROWTemplateId]) ON [PRIMARY]
GO
