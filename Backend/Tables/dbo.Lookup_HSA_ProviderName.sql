CREATE TABLE [dbo].[Lookup_HSA_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_HSA_ProviderName] ADD CONSTRAINT [PK__Lookup_H__C41E028820AD9DE2] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
