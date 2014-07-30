CREATE TABLE [dbo].[Lookup_OGA_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_OGA_ProviderName] ADD CONSTRAINT [PK__Lookup_O__C41E0288686944BF] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
