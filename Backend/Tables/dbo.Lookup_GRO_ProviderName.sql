CREATE TABLE [dbo].[Lookup_GRO_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_GRO_ProviderName] ADD CONSTRAINT [PK__Lookup_G__C41E028840B05920] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
