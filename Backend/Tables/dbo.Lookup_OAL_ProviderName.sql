CREATE TABLE [dbo].[Lookup_OAL_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_OAL_ProviderName] ADD CONSTRAINT [PK__Lookup_O__C41E0288700A6687] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
