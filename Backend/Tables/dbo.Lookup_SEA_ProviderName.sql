CREATE TABLE [dbo].[Lookup_SEA_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_SEA_ProviderName] ADD CONSTRAINT [PK__Lookup_S__C41E0288413A6905] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
