CREATE TABLE [dbo].[Lookup_PSO_Sections]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_PSO_Sections] ADD CONSTRAINT [PK__Lookup_P__C41E0288025E20EC] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
