CREATE TABLE [dbo].[LogConfiguration]
(
[LogConfigurationID] [int] NOT NULL IDENTITY(1, 1),
[ApplicationName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApplicationCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF__LogConfig__IsAct__676A338E] DEFAULT ((1)),
[DatabaseEnabled] [bit] NOT NULL CONSTRAINT [DF__LogConfig__Datab__685E57C7] DEFAULT ((1)),
[EmailEnabled] [bit] NOT NULL CONSTRAINT [DF__LogConfig__Email__69527C00] DEFAULT ((0)),
[EmailTo] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailFrom] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailSubject] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailSMTP] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileEnabled] [bit] NOT NULL CONSTRAINT [DF__LogConfig__FileE__6A46A039] DEFAULT ((0)),
[LogFileName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogFilePath] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventLogEnabled] [bit] NOT NULL CONSTRAINT [DF__LogConfig__Event__6B3AC472] DEFAULT ((0)),
[IsPublicApp] [bit] NOT NULL CONSTRAINT [DF__LogConfig__IsPub__6C2EE8AB] DEFAULT ((0)),
[PublicAppApiBaseUri] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PublicAppApiUri] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsPublicWeb] [bit] NOT NULL CONSTRAINT [DF__LogConfig__IsPub__6D230CE4] DEFAULT ((0)),
[PublicWebApiBaseUri] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PublicWebApiUri] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__LogConfig__Creat__6E17311D] DEFAULT (getdate()),
[UpdatedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogConfiguration] ADD CONSTRAINT [PK_LogApplications] PRIMARY KEY CLUSTERED  ([LogConfigurationID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogConfiguration] ADD CONSTRAINT [UQ__LogConfi__1185325A43E4B02C] UNIQUE NONCLUSTERED  ([ApplicationCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LogConfiguration] ADD CONSTRAINT [UQ__LogConfi__30910331523B6BE4] UNIQUE NONCLUSTERED  ([ApplicationName]) ON [PRIMARY]
GO
