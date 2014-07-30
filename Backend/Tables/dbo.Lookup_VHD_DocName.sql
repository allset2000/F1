CREATE TABLE [dbo].[Lookup_VHD_DocName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_VHD_DocName] ADD CONSTRAINT [PK_Lookup_VHD_DocName] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
