CREATE TABLE [dbo].[EditorLogs]
(
[EditorLogId] [int] NOT NULL IDENTITY(1, 1),
[EditorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OperationTime] [datetime] NOT NULL,
[OperationName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SuccessFlag] [bit] NOT NULL,
[ExceptionMessage] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionID] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_EditorLogs_JobNumber] ON [dbo].[EditorLogs] ([JobNumber] DESC) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_EditorLogs_OperationTime] ON [dbo].[EditorLogs] ([OperationTime]) ON [PRIMARY]

ALTER TABLE [dbo].[EditorLogs] ADD 
CONSTRAINT [PK_EditorLog] PRIMARY KEY CLUSTERED  ([EditorLogId] DESC) ON [PRIMARY]
GO
