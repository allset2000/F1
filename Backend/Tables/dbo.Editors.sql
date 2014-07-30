CREATE TABLE [dbo].[Editors]
(
[EditorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditorPwd] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobCount] [smallint] NULL,
[JobMax] [smallint] NULL,
[JobStat] [smallint] NULL,
[AutoDownload] [bit] NULL,
[Managed] [bit] NULL,
[ManagedBy] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClinicID] [smallint] NULL,
[EnableAudit] [bit] NULL,
[SignOff1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SignOff2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SignOff3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RoleID] [smallint] NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MI] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [smallint] NULL,
[IdleTime] [smallint] NULL CONSTRAINT [DF_Editors_IdleTime] DEFAULT ((30)),
[EditorIdOk] [int] NULL,
[EditorCompanyId] [int] NOT NULL,
[EditorQAIDMatch] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Editors_EditorQAIDMatch] DEFAULT (''),
[EditorEMail] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Editors_EditorEMail] DEFAULT ('')
) ON [PRIMARY]
CREATE UNIQUE NONCLUSTERED INDEX [IX_EditorsEditorIdOk] ON [dbo].[Editors] ([EditorIdOk]) ON [PRIMARY]

GO
EXEC sp_addextendedproperty N'MS_Description', N'Enable AutoDownload', 'SCHEMA', N'dbo', 'TABLE', N'Editors', 'COLUMN', N'AutoDownload'
GO

EXEC sp_addextendedproperty N'MS_Description', N'Which Clinic is this Editor from?', 'SCHEMA', N'dbo', 'TABLE', N'Editors', 'COLUMN', N'ClinicID'
GO

EXEC sp_addextendedproperty N'MS_Description', N'Enable Auditing', 'SCHEMA', N'dbo', 'TABLE', N'Editors', 'COLUMN', N'EnableAudit'
GO

EXEC sp_addextendedproperty N'MS_Description', N'#Job to AutoDownload', 'SCHEMA', N'dbo', 'TABLE', N'Editors', 'COLUMN', N'JobCount'
GO

EXEC sp_addextendedproperty N'MS_Description', N'Max #jobs a user can have', 'SCHEMA', N'dbo', 'TABLE', N'Editors', 'COLUMN', N'JobMax'
GO

EXEC sp_addextendedproperty N'MS_Description', N'Max #stat jobs a user can have', 'SCHEMA', N'dbo', 'TABLE', N'Editors', 'COLUMN', N'JobStat'
GO

EXEC sp_addextendedproperty N'MS_Description', N'Is this a Managed Editor', 'SCHEMA', N'dbo', 'TABLE', N'Editors', 'COLUMN', N'Managed'
GO

EXEC sp_addextendedproperty N'MS_Description', N'By Whom?', 'SCHEMA', N'dbo', 'TABLE', N'Editors', 'COLUMN', N'ManagedBy'
GO

EXEC sp_addextendedproperty N'MS_Description', N'10-Editor / 20-QA', 'SCHEMA', N'dbo', 'TABLE', N'Editors', 'COLUMN', N'Type'
GO

ALTER TABLE [dbo].[Editors] ADD CONSTRAINT [PK_Editors] PRIMARY KEY CLUSTERED  ([EditorID]) ON [PRIMARY]
GO
