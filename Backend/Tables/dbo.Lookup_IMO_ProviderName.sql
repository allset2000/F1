CREATE TABLE [dbo].[Lookup_IMO_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_IMO_ProviderName] ADD CONSTRAINT [PK__Lookup_I__C41E0288705F6C42] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
