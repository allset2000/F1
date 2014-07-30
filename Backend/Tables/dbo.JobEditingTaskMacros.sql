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
