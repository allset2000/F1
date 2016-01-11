CREATE TABLE [dbo].[Modules]
(
[ModuleId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationId] [int] NOT NULL,
[ModuleName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_Module_IsDeleted] DEFAULT ((0)),
[DateCreated] [datetime] NOT NULL,
[DateUpdated] [datetime] NOT NULL,
[ModuleCode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Modules_ModuleCode] DEFAULT ('UNKNOWN')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Modules] ADD CONSTRAINT [PK_Module] PRIMARY KEY CLUSTERED  ([ModuleId]) ON [PRIMARY]
GO
