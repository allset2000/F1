CREATE TABLE [dbo].[Lookup_Athena_Clinic]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_Athena_Clinic] ADD CONSTRAINT [PK_Lookup_Athena_Clinic] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
