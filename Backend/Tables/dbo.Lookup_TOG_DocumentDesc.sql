CREATE TABLE [dbo].[Lookup_TOG_DocumentDesc]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_TOG_DocumentDesc] ADD CONSTRAINT [PK__Lookup_T__C41E0288383021B8] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
