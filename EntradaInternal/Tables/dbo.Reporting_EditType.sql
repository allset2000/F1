CREATE TABLE [dbo].[Reporting_EditType]
(
[ClinicID] [smallint] NOT NULL,
[EditType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reporting_EditType] ADD CONSTRAINT [PK__Reportin__3347C2FD4336F4B9] PRIMARY KEY CLUSTERED  ([ClinicID]) ON [PRIMARY]
GO
