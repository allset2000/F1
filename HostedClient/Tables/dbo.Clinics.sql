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
[EHRLocationID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Clinics_EHRLocationID] DEFAULT (''),
[ClinicCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Clinics_ClinicCode] DEFAULT (''),
[DisableUpdateAlert] [bit] NOT NULL CONSTRAINT [DF_Clinics_DisableUpdateAlert] DEFAULT ((0)),
[CRFlagType] [int] NOT NULL CONSTRAINT [DF_Clinics_CRFlagType] DEFAULT ((0)),
[ForceCRStartDate] [datetime] NULL,
[ForceCREndDate] [datetime] NULL,
[ExcludeStat] [bit] NOT NULL CONSTRAINT [DF_Clinics_ExcludeStat] DEFAULT ((0)),
[AutoEnrollDevices] [bit] NOT NULL CONSTRAINT [DF_Clinics_AutoEnrollDevices] DEFAULT ((0)),
[SRETypeId] [int] NULL,
[DisablePatientImages] [bit] NOT NULL CONSTRAINT [DF_Clinics_DisablePatientImages] DEFAULT ((0)),
[PortalTimeout] [int] NULL,
[DaysToResetPassword] [int] NULL,
[PreviousPasswordCount] [int] NULL,
[PasswordMinCharacters] [int] NULL,
[FailedPasswordLockoutCount] [int] NULL,
[TimeZoneId] [int] NULL,
[RealTimeClinicIP] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RealTimeClinicPortNo] [int] NULL,
[RealTimeEnabled] [bit] NOT NULL CONSTRAINT [DF_Clinics_RealTimeEnabled] DEFAULT ((0))
) ON [PRIMARY]
ALTER TABLE [dbo].[Clinics] ADD
CONSTRAINT [fk_clinic_SRETypeId] FOREIGN KEY ([SRETypeId]) REFERENCES [dbo].[SREEngineType] ([SRETypeId])

GO
ALTER TABLE [dbo].[Clinics] ADD CONSTRAINT [PK_Clinics] PRIMARY KEY CLUSTERED  ([ClinicID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Clinics_MobileCode] ON [dbo].[Clinics] ([MobileCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Clinics] ADD CONSTRAINT [FK_Clinics_CRFlagTypes] FOREIGN KEY ([CRFlagType]) REFERENCES [dbo].[CRFlagTypes] ([CRFlagType])
GO
