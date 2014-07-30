CREATE TABLE [dbo].[JobDueDateHistory]
(
[LogId] [int] NOT NULL IDENTITY(1, 1),
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OperationName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobDueDate] [datetime] NULL,
[OperationTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobDueDateHistory] ADD CONSTRAINT [PK_JobDueDateHistory] PRIMARY KEY CLUSTERED  ([LogId]) ON [PRIMARY]
GO
