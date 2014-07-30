CREATE TABLE [dbo].[Lookup_SVP_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_SVP_ProviderName] ADD CONSTRAINT [PK__Lookup_S__C41E0288192C77AB] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
