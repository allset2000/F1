CREATE TABLE [dbo].[Jobs_Template_Tags]
(
[JobTemplateID] [bigint] NOT NULL IDENTITY(1, 1),
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TemplateName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Template_Tags] ADD CONSTRAINT [PK_Jobs_Template_Tags] PRIMARY KEY CLUSTERED  ([JobTemplateID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobsTemplateTags_Jobnumber] ON [dbo].[Jobs_Template_Tags] ([JobTemplateID]) ON [PRIMARY]
GO
