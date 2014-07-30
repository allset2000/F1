CREATE TABLE [dbo].[Lookup_MUG_Sections]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_MUG_Sections] ADD CONSTRAINT [PK_Lookup_MUG_Sections] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
