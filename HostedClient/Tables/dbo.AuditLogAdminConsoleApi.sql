CREATE TABLE [dbo].[AuditLogAdminConsoleApi]
(
[LogID] [bigint] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[RequestID] [uniqueidentifier] NOT NULL,
[Operation] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SiteUrl] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parameters] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OperationTime] [datetime] NOT NULL,
[ExecutionTime] [int] NOT NULL,
[Success] [bit] NOT NULL,
[Exception] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuditLogAdminConsoleApi] ADD CONSTRAINT [PK_AuditLogAdminConsole] PRIMARY KEY CLUSTERED  ([LogID]) ON [PRIMARY]
GO
