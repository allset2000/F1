CREATE TABLE [dbo].[Lookup_WOH_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_WOH_ProviderName] ADD CONSTRAINT [PK__Lookup_W__C41E02883573B09E] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
