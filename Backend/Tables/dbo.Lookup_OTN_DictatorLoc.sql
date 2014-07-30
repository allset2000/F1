CREATE TABLE [dbo].[Lookup_OTN_DictatorLoc]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_OTN_DictatorLoc] ADD CONSTRAINT [PK_Lookup_OTN_DictatorLoc] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[Lookup_OTN_DictatorLoc] TO [mcardwell]
GRANT DELETE ON  [dbo].[Lookup_OTN_DictatorLoc] TO [mcardwell]
GRANT UPDATE ON  [dbo].[Lookup_OTN_DictatorLoc] TO [mcardwell]
GRANT SELECT ON  [dbo].[Lookup_OTN_DictatorLoc] TO [mmoscoso]
GRANT INSERT ON  [dbo].[Lookup_OTN_DictatorLoc] TO [mmoscoso]
GRANT UPDATE ON  [dbo].[Lookup_OTN_DictatorLoc] TO [mmoscoso]
GO
