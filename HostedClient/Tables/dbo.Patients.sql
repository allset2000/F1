CREATE TABLE [dbo].[Patients]
(
[PatientID] [int] NOT NULL IDENTITY(1, 1),
[ClinicID] [smallint] NOT NULL,
[MRN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_MRN] DEFAULT (''),
[AlternateID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_AlternateID] DEFAULT (''),
[FirstName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_FirstName] DEFAULT (''),
[MI] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_MI] DEFAULT (''),
[LastName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_LastName] DEFAULT (''),
[Suffix] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_Suffix] DEFAULT (''),
[Gender] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_Gender] DEFAULT (''),
[Address1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_Address1] DEFAULT (''),
[Address2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_Address2] DEFAULT (''),
[City] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_City] DEFAULT (''),
[State] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_State] DEFAULT (''),
[Zip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_Zip] DEFAULT (''),
[DOB] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_DOB] DEFAULT (''),
[Phone1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_Phone1] DEFAULT (''),
[Phone2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_Phone2] DEFAULT (''),
[Fax1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_Fax1] DEFAULT (''),
[Fax2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Patients_Fax2] DEFAULT (''),
[PrimaryCareProviderID] [int] NULL
) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ClinicID_INC_MRN_FirstName_MI_LastName] ON [dbo].[Patients] ([ClinicID]) INCLUDE ([FirstName], [LastName], [MI], [MRN]) ON [PRIMARY]



ALTER TABLE [dbo].[Patients] ADD
CONSTRAINT [FK_Patients_ReferringPhysicians] FOREIGN KEY ([PrimaryCareProviderID]) REFERENCES [dbo].[ReferringPhysicians] ([ReferringID])


CREATE NONCLUSTERED INDEX [IX_Patients] ON [dbo].[Patients] ([AlternateID]) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Patients] ADD CONSTRAINT [PK_Patients] PRIMARY KEY CLUSTERED  ([PatientID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Patients] ADD CONSTRAINT [UNQ__Patients__MRN] UNIQUE NONCLUSTERED  ([ClinicID], [MRN]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Patients] ADD CONSTRAINT [FK_Patients_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID]) ON DELETE CASCADE
GO
