CREATE TABLE [dbo].[Lookup_MDO_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_MDO_ProviderName] ADD CONSTRAINT [PK__Lookup_M__C41E02882A5703AD] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
