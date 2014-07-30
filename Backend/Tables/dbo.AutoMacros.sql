CREATE TABLE [dbo].[AutoMacros]
(
[ClinicID] [smallint] NOT NULL,
[PatientID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MacroName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MacroText] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AutoMacros] ADD CONSTRAINT [PK_AutoMacros] PRIMARY KEY CLUSTERED  ([ClinicID], [PatientID]) ON [PRIMARY]
GO
