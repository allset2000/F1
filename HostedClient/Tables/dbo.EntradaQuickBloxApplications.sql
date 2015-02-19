CREATE TABLE [dbo].[EntradaQuickBloxApplications]
(
[ApplicationID] [int] NOT NULL,
[ApplicationTitle] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AuthorizationKey] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AuthorizationSecret] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EntradaQuickBloxApplications] ADD CONSTRAINT [PK_EntradaQuickBloxApplications] PRIMARY KEY CLUSTERED  ([ApplicationID]) ON [PRIMARY]
GO
