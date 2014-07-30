CREATE TABLE [dbo].[Lookup_SPS_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_SPS_ProviderName] ADD CONSTRAINT [PK__Lookup_S__C41E028812B48446] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
