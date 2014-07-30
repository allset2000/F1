CREATE TABLE [dbo].[Lookup_MCO_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_MCO_ProviderName] ADD CONSTRAINT [PK__Lookup_M__C41E02880DBAC4FF] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
