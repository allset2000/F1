CREATE TABLE [dbo].[ROW_Lookup]
(
[ClinicID] [smallint] NOT NULL,
[Category] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Key] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ROW_Lookup] ADD CONSTRAINT [PK_ROW_Lookup] PRIMARY KEY CLUSTERED  ([ClinicID], [Category], [Key]) ON [PRIMARY]
GO
