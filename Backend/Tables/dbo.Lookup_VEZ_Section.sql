CREATE TABLE [dbo].[Lookup_VEZ_Section]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_VEZ_Section] ADD CONSTRAINT [PK_Lookup_VEZ_Section] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
