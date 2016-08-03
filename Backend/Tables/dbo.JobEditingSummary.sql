CREATE TABLE [dbo].[JobEditingSummary]
(
[JobId] [int] NOT NULL,
[LastEditedByID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrentlyEditedByID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastQAEditorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrentStateId] [int] NOT NULL,
[CurrentQAStage] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastQAStage] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AssignedToID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QACategoryId] [int] NOT NULL,
[LastQANote] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QAEditorsList] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FinishedOn] [smalldatetime] NULL,
[EditorEditingTaskId] [int] NOT NULL,
[LastEditingTaskId] [int] NOT NULL,
[LastQAEditingTaskId] [int] NOT NULL,
[BillingEditingTaskId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobEditingSummary] ADD CONSTRAINT [PK_JobEditingSummary] PRIMARY KEY CLUSTERED  ([JobId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ON_AssignedToID_WITH_INC] ON [dbo].[JobEditingSummary] ([AssignedToID]) INCLUDE ([JobId], [QACategoryId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JobEditingSummary_CurrentStateId] ON [dbo].[JobEditingSummary] ([CurrentStateId]) INCLUDE ([BillingEditingTaskId], [JobId]) ON [PRIMARY]
GO
