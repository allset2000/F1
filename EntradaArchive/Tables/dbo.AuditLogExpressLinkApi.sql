CREATE TABLE [dbo].[AuditLogExpressLinkApi]
(
[LogID] [bigint] NOT NULL,
[ApiKey] [uniqueidentifier] NULL,
[ConfigID] [int] NULL,
[Operation] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Parameters] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OperationTime] [datetime] NOT NULL CONSTRAINT [DF_AuditLogExpressLinkApi_OperationTime] DEFAULT (getdate()),
[ExecutionTime] [int] NOT NULL,
[Success] [bit] NOT NULL,
[Exception] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArchiveID] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuditLogExpressLinkApi] ADD CONSTRAINT [PK_AuditLogExpressLinkApi] PRIMARY KEY CLUSTERED  ([LogID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuditLogExpressLinkApi] ADD CONSTRAINT [FK_AuditLogExpressLinkApi_ArchiveLog] FOREIGN KEY ([ArchiveID]) REFERENCES [dbo].[ArchiveLog] ([ArchiveID])
GO
