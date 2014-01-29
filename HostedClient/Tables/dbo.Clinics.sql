CREATE TABLE [dbo].[Clinics]
(
[ClinicID] [smallint] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MobileCode] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Clinics_Code] DEFAULT (''),
[AccountManagerID] [smallint] NOT NULL CONSTRAINT [DF_Clinics_AccountManagerID] DEFAULT ((1)),
[ExpressQueuesEnabled] [bit] NOT NULL CONSTRAINT [DF_Clinics_ExpressQueues] DEFAULT ((0)),
[ImageCaptureEnabled] [bit] NOT NULL CONSTRAINT [DF_Clinics_ImageCaptureEnabled] DEFAULT ((0)),
[PatientClinicalsEnabled] [bit] NOT NULL CONSTRAINT [DF_Clinics_PatientClinicalsEnabled] DEFAULT ((0)),
[Deleted] [bit] NOT NULL CONSTRAINT [DF_Clinics_Active] DEFAULT ((0)),
[EHRVendorID] [smallint] NOT NULL,
[EHRClinicID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Clinics_EHRClinicID] DEFAULT (''),
[EHRLocationID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Clinics_EHRLocationID] DEFAULT ('')
) ON [PRIMARY]
ALTER TABLE [dbo].[Clinics] ADD 
CONSTRAINT [PK_Clinics] PRIMARY KEY CLUSTERED  ([ClinicID]) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Clinics_MobileCode] ON [dbo].[Clinics] ([MobileCode]) ON [PRIMARY]

GO
