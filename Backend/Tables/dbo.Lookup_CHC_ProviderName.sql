CREATE TABLE [dbo].[Lookup_CHC_ProviderName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_CHC_ProviderName] ADD CONSTRAINT [PK__Lookup_C__C41E02887C9038FD] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
