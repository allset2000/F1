CREATE TABLE [dbo].[Lookup_Athena_Sections]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_Athena_Sections] ADD CONSTRAINT [PK__Lookup_A__C41E02887E8D9008] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
