CREATE TABLE [dbo].[Lookup_MCO_JobTypeCode]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_MCO_JobTypeCode] ADD CONSTRAINT [PK_Lookup_MCO_ProviderCode] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
