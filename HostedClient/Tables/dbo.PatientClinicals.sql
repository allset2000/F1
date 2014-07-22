CREATE TABLE [dbo].[PatientClinicals]
(
[ID] [bigint] NOT NULL IDENTITY(1, 1),
[PatientID] [int] NOT NULL,
[Category] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Data] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EHRControlID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PatientClinicals] ADD CONSTRAINT [PK_PatientClinicals] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PatientClinicals] ON [dbo].[PatientClinicals] ([PatientID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PatientClinicals] ADD CONSTRAINT [FK_PatientClinicals_Patients] FOREIGN KEY ([PatientID]) REFERENCES [dbo].[Patients] ([PatientID])
GO
