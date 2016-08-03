CREATE TABLE [dbo].[JobsTddAllowedTags]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SplitRuleID] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Required] [bit] NOT NULL CONSTRAINT [DF_JobsTddAllowedTags_Required] DEFAULT ((0)),
[FieldName] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_JobsTddAllowedTags_FieldName] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobsTddAllowedTags] ADD CONSTRAINT [PK_JobsTddAllowedTags] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobsTddAllowedTags_SplitRuleID] ON [dbo].[JobsTddAllowedTags] ([SplitRuleID]) INCLUDE ([FieldName], [ID], [Name], [Required]) ON [PRIMARY]
GO
