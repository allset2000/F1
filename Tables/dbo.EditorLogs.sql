CREATE TABLE [dbo].[EditorLogs]
(
[EditorLogId] [int] NOT NULL,
[EditorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OperationTime] [datetime] NOT NULL,
[OperationName] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SuccessFlag] [bit] NOT NULL,
[ExceptionMessage] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionID] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ArchiveID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EditorLogs] ADD CONSTRAINT [PK_EditorLog] PRIMARY KEY CLUSTERED  ([EditorLogId] DESC) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EditorLogs] ADD CONSTRAINT [FK_EditorLogs_ArchiveLog] FOREIGN KEY ([ArchiveID]) REFERENCES [dbo].[ArchiveLog] ([ArchiveID])
GO
