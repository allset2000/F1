CREATE TABLE [dbo].[Lookup_OA_HL7DocName]
(
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lookup_OA_HL7DocName] ADD CONSTRAINT [PK_Lookup_OA_HL7DocName] PRIMARY KEY CLUSTERED  ([Key]) ON [PRIMARY]
GO
