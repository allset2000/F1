CREATE TABLE [dbo].[Lookup_TSC_TaskNumber]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_TSC_TaskNumber] ADD CONSTRAINT [PK_Lookup_TSC_TaskNumber] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[Lookup_TSC_TaskNumber] TO [mcardwell]
GRANT DELETE ON  [dbo].[Lookup_TSC_TaskNumber] TO [mcardwell]
GRANT UPDATE ON  [dbo].[Lookup_TSC_TaskNumber] TO [mcardwell]
GRANT SELECT ON  [dbo].[Lookup_TSC_TaskNumber] TO [mmoscoso]
GRANT INSERT ON  [dbo].[Lookup_TSC_TaskNumber] TO [mmoscoso]
GRANT UPDATE ON  [dbo].[Lookup_TSC_TaskNumber] TO [mmoscoso]
GO
