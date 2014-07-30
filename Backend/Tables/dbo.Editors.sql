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
[EditorIdOk] [int] NOT NULL CONSTRAINT [DF_Editors_EditorIdOk] DEFAULT ((0)),
[EditorCompanyId] [int] NOT NULL CONSTRAINT [DF_Editors_EditorCompanyId] DEFAULT ((-1)),
[EditorQAIDMatch] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Editors_EditorQAIDMatch] DEFAULT (''),
[EditorEMail] [varchar] (48) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Editors_EditorEMail] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Editors] ADD CONSTRAINT [PK_Editors] PRIMARY KEY CLUSTERED  ([EditorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Editors_EditorIdOk] ON [dbo].[Editors] ([EditorIdOk]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Editors] ADD CONSTRAINT [FK_Editors_Companies] FOREIGN KEY ([EditorCompanyId]) REFERENCES [dbo].[Companies] ([CompanyId])
GO
