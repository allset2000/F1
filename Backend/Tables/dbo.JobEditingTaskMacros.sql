CREATE TABLE [dbo].[JobEditingTaskMacros]
(
[JobEditingTaskMacroId] [int] NOT NULL IDENTITY(1, 1),
[JobEditingTaskId] [int] NOT NULL,
[MacroName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WasEdited] [bit] NOT NULL,
[NumCharsUnEdited] [int] NOT NULL,
[NumCharsEdited] [int] NOT NULL,
[NumCharsChanged] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobEditingTaskMacros] ADD CONSTRAINT [PK_JobEditingTaskDataDetail_1] PRIMARY KEY CLUSTERED  ([JobEditingTaskMacroId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobEditingTaskDataDetail_JobEditingTaskId] ON [dbo].[JobEditingTaskMacros] ([JobEditingTaskId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the Macro', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTaskMacros', 'COLUMN', N'MacroName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters that were changed in the Macro', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTaskMacros', 'COLUMN', N'NumCharsChanged'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters the Macro has after edit is complete', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTaskMacros', 'COLUMN', N'NumCharsEdited'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Characters the Macro has without any edit', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTaskMacros', 'COLUMN', N'NumCharsUnEdited'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Was the Macro Edited?', 'SCHEMA', N'dbo', 'TABLE', N'JobEditingTaskMacros', 'COLUMN', N'WasEdited'
GO
