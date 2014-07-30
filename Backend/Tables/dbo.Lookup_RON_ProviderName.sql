CREATE TABLE [dbo].[Lookup_RON_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_RON_ProviderName] ADD CONSTRAINT [PK__Lookup_R__C41E0288407B4EF6] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
