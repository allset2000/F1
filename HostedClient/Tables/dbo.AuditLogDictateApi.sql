CREATE TABLE [dbo].[AuditLogDictateApi]
(
[LogID] [bigint] NOT NULL IDENTITY(1, 1),
[DictatorID] [int] NOT NULL,
[Operation] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Parameters] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OperationTime] [datetime] NOT NULL,
[ExecutionTime] [int] NOT NULL,
[Success] [bit] NOT NULL,
[Exception] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_AuditLogDictateAPI_DictatorID] ON [dbo].[AuditLogDictateApi] ([DictatorID]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[AuditLogDictateApi] ADD CONSTRAINT [PK_AuditLogDictateApi] PRIMARY KEY CLUSTERED  ([LogID]) ON [PRIMARY]
GO
