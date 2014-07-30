CREATE TABLE [dbo].[AuditLog]
(
[AuditLogId] [int] NOT NULL IDENTITY(1, 1),
[UserName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_AuditLog_UserName] DEFAULT (''),
[OperationTime] [datetime] NOT NULL CONSTRAINT [DF_AuditLog_OperationTime] DEFAULT (getdate()),
[OperationName] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_AuditLog_OperationName] DEFAULT (''),
[ReferenceTag] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_AuditLog_ReferenceTag] DEFAULT (''),
[Dictator] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_AuditLog_Dictator] DEFAULT (''),
[AuditLogType] [int] NOT NULL CONSTRAINT [DF_AuditLog_AuditLogType] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuditLog] ADD CONSTRAINT [PK_AuditLog] PRIMARY KEY CLUSTERED  ([AuditLogId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'{0=Not defined, 1=Macros, 2=AutoText}', 'SCHEMA', N'dbo', 'TABLE', N'AuditLog', 'COLUMN', N'AuditLogType'
GO
