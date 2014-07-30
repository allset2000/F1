CREATE TABLE [dbo].[Lookup_CMC_DocSignature]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_CMC_DocSignature] ADD CONSTRAINT [PK_Lookup_CMC_DocSignature] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[Lookup_CMC_DocSignature] TO [mmoscoso]
GRANT INSERT ON  [dbo].[Lookup_CMC_DocSignature] TO [mmoscoso]
GRANT UPDATE ON  [dbo].[Lookup_CMC_DocSignature] TO [mmoscoso]
GO
