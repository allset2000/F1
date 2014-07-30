CREATE TABLE [dbo].[JobEditingTasks]
(
[JobEditingTaskId] [int] NOT NULL,
[JobId] [int] NOT NULL,
[AssignedToID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditionNote] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QACategoryId] [int] NOT NULL CONSTRAINT [DF_JobEditingTrack_QACategoryId] DEFAULT ((-1)),
[CurrentStateId] [int] NOT NULL,
[NextStateId] [int] NOT NULL,
[WorkflowRuleId] [int] NOT NULL,
[AssignmentMode] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AssignedById] [int] NOT NULL,
[ReleasedById] [int] NOT NULL,
[AssignedOn] [datetime] NOT NULL,
[ReceivedOn] [datetime] NOT NULL,
[ReturnedOn] [datetime] NOT NULL,
[PreviousTaskId] [int] NOT NULL,
[NextTaskId] [int] NOT NULL,
[TaskStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobEditingTasks] ADD CONSTRAINT [PK_JobEditingTrack] PRIMARY KEY CLUSTERED  ([JobEditingTaskId]) ON [PRIMARY]
GO
