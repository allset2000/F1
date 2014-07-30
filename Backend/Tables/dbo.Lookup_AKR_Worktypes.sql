CREATE TABLE [dbo].[Lookup_AKR_Worktypes]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_AKR_Worktypes] ADD CONSTRAINT [PK_Lookup_AKR_Worktypes] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[Lookup_AKR_Worktypes] TO [mcardwell]
GRANT DELETE ON  [dbo].[Lookup_AKR_Worktypes] TO [mcardwell]
GRANT UPDATE ON  [dbo].[Lookup_AKR_Worktypes] TO [mcardwell]
GRANT SELECT ON  [dbo].[Lookup_AKR_Worktypes] TO [mmoscoso]
GRANT INSERT ON  [dbo].[Lookup_AKR_Worktypes] TO [mmoscoso]
GRANT UPDATE ON  [dbo].[Lookup_AKR_Worktypes] TO [mmoscoso]
GO
