CREATE TABLE [dbo].[Jobs_Patients]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AlternateID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MRN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MI] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sex] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientId] [int] NOT NULL CONSTRAINT [DF_Jobs_Patients_PatientId] DEFAULT ((0)),
[AppointmentId] [int] NOT NULL CONSTRAINT [DF_Jobs_Patients_AppointmentId] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Patients] ADD CONSTRAINT [PK_Jobs_Patients] PRIMARY KEY CLUSTERED  ([JobNumber] DESC) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Jobs_Patients_PatientId] ON [dbo].[Jobs_Patients] ([PatientId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jobs_Patients] ADD CONSTRAINT [FK_Jobs_Patients_Jobs] FOREIGN KEY ([JobNumber]) REFERENCES [dbo].[Jobs] ([JobNumber])
GO
