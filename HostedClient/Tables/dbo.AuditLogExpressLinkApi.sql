CREATE TABLE [dbo].[AuditLogExpressLinkApi]
(
[LogID] [bigint] NOT NULL IDENTITY(1, 1),
[ApiKey] [uniqueidentifier] NULL,
[ConfigID] [int] NULL,
[Operation] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Parameters] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OperationTime] [datetime] NOT NULL CONSTRAINT [DF_AuditLogExpressLinkApi_OperationTime] DEFAULT (getdate()),
[ExecutionTime] [int] NOT NULL,
[Success] [bit] NOT NULL,
[Exception] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_AuditlogExpressLinkAPI_ConfigID] ON [dbo].[AuditLogExpressLinkApi] ([ConfigID] DESC, [OperationTime] DESC) ON [PRIMARY]

GO
ALTER TABLE [dbo].[AuditLogExpressLinkApi] ADD CONSTRAINT [PK_AuditLogExpressLinkApi] PRIMARY KEY CLUSTERED  ([LogID]) ON [PRIMARY]
GO
