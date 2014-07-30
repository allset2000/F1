CREATE TABLE [dbo].[Lookup_CMA_DocName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_CMA_DocName] ADD CONSTRAINT [PK_Lookup_CMA_DocName] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[Lookup_CMA_DocName] TO [mcardwell]
GRANT DELETE ON  [dbo].[Lookup_CMA_DocName] TO [mcardwell]
GRANT UPDATE ON  [dbo].[Lookup_CMA_DocName] TO [mcardwell]
GO
