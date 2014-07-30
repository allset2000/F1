CREATE TABLE [dbo].[Lookup_PSO_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_PSO_ProviderName] ADD CONSTRAINT [PK__Lookup_P__C41E02880EC3F7D1] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
