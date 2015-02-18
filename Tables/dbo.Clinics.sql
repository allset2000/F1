CREATE TABLE [dbo].[Clinics]
(
[ClinicID] [smallint] NOT NULL,
[ClinicName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClinicCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumCharsPerLine] [smallint] NULL,
[PageRate] [money] NULL,
[LineRate] [money] NULL,
[SecondRate] [money] NULL,
[EditPageRate] [money] NULL,
[EditLineRate] [money] NULL,
[EditSecondRate] [money] NULL,
[ClinicReviewEnabled] [bit] NULL,
[ESignatureEnabled] [bit] NULL,
[CloseDocuments] [bit] NULL,
[NumDaysToClose] [smallint] NULL,
[Active] [bit] NULL CONSTRAINT [DF_Clinics_Active] DEFAULT ((1)),
[NumDictators] [smallint] NULL CONSTRAINT [DF_Clinics_NumDictators] DEFAULT ((0)),
[EnableTDD] [bit] NULL CONSTRAINT [DF_Clinics_EnableTDD] DEFAULT ((0)),
[JobTag] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientTag] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HostedModel] [bit] NOT NULL CONSTRAINT [DF_Clinics_HostedModel] DEFAULT ((0)),
[HostedClinicId] [smallint] NOT NULL CONSTRAINT [DF_Clinics_HostedClinicId] DEFAULT ((-1)),
[EHRClinicID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingEMail] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Clinics_BillingEMail] DEFAULT (''),
[BillingSalesTerm] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Clinics_BillingSalesTerm] DEFAULT (''),
[SubscriptionsNum] [int] NOT NULL CONSTRAINT [DF_Clinics_SubscriptionsNum] DEFAULT ((0)),
[SreType] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__Clinics__SreType__2937F6EB] DEFAULT ('NOSRE')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Clinics] ADD CONSTRAINT [PK_Clinics] PRIMARY KEY CLUSTERED  ([ClinicID]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[Clinics] TO [app_DocExtract]
GO
