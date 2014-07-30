CREATE TABLE [dbo].[Lookup_TOA_AutoTaskNumber]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_TOA_AutoTaskNumber] ADD CONSTRAINT [PK_Lookup_TOA_AutoTaskNumber] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[Lookup_TOA_AutoTaskNumber] TO [mcardwell]
GRANT DELETE ON  [dbo].[Lookup_TOA_AutoTaskNumber] TO [mcardwell]
GRANT UPDATE ON  [dbo].[Lookup_TOA_AutoTaskNumber] TO [mcardwell]
GRANT SELECT ON  [dbo].[Lookup_TOA_AutoTaskNumber] TO [mmoscoso]
GRANT INSERT ON  [dbo].[Lookup_TOA_AutoTaskNumber] TO [mmoscoso]
GRANT UPDATE ON  [dbo].[Lookup_TOA_AutoTaskNumber] TO [mmoscoso]
GO
