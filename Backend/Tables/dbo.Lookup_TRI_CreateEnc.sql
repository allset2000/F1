CREATE TABLE [dbo].[Lookup_TRI_CreateEnc]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_TRI_CreateEnc] ADD CONSTRAINT [PK_Lookup_TRI_CreateEnc] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[Lookup_TRI_CreateEnc] TO [mcardwell]
GRANT DELETE ON  [dbo].[Lookup_TRI_CreateEnc] TO [mcardwell]
GRANT UPDATE ON  [dbo].[Lookup_TRI_CreateEnc] TO [mcardwell]
GRANT SELECT ON  [dbo].[Lookup_TRI_CreateEnc] TO [mmoscoso]
GRANT INSERT ON  [dbo].[Lookup_TRI_CreateEnc] TO [mmoscoso]
GRANT UPDATE ON  [dbo].[Lookup_TRI_CreateEnc] TO [mmoscoso]
GO
