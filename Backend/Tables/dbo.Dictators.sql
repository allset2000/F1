/*CREATE TABLE [dbo].[Dictators]
(
[ClinicID] [smallint] NOT NULL,
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ClientUserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DefaultLocation] [smallint] NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MI] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Initials] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TemplatesFolder] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Signature] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[User_Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ForkAudio] [bit] NULL,
[VREnabled] [bit] NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SignUpDate] [smalldatetime] NULL,
[FirstDictation] [smalldatetime] NULL,
[DictatorBillingDate] [smalldatetime] NULL,
[NumCharsPerLine] [smallint] NULL,
[PageRate] [money] NULL,
[LineRate] [money] NULL,
[SecondRate] [money] NULL,
[EditPageRate] [money] NULL,
[EditLineRate] [money] NULL,
[EditSecondRate] [money] NULL,
[ClinicReviewEnabled] [bit] NULL,
[ESignatureEnabled] [bit] NULL,
[ESignatureStamp] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ESignatureLocation] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CloseDocuments] [bit] NULL,
[NumDaysToClose] [smallint] NULL,
[DictatorIdOk] [int] NULL CONSTRAINT [DF_Dictators_DictatorIdOk] DEFAULT ((0)),
[EHRProviderID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EHRAliasID] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProviderType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Dictators_ProviderType] DEFAULT (''),
[BillSeparated] [bit] NOT NULL CONSTRAINT [DF_Dictators_BillSeparated] DEFAULT ((0)),
[PhoneNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FaxNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MedicalLicenseNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom1] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom2] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom3] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom4] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom5] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SreTypeId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [PK_Dictators] PRIMARY KEY CLUSTERED  ([DictatorID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_DictatorsDictatorIdOk] ON [dbo].[Dictators] ([DictatorIdOk]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Dictators] ADD CONSTRAINT [FK_Dictators_Locations] FOREIGN KEY ([ClinicID], [DefaultLocation]) REFERENCES [dbo].[Locations] ([ClinicID], [LocationID])
GO

GRANT SELECT ON  [dbo].[Dictators] TO [app_DocExtract]
GRANT VIEW DEFINITION ON  [dbo].[Dictators] TO [ENTRADAHEALTH\SQLImplementation]
GRANT SELECT ON  [dbo].[Dictators] TO [ENTRADAHEALTH\SQLImplementation]
GRANT INSERT ON  [dbo].[Dictators] TO [ENTRADAHEALTH\SQLImplementation]
GRANT DELETE ON  [dbo].[Dictators] TO [ENTRADAHEALTH\SQLImplementation]
GRANT UPDATE ON  [dbo].[Dictators] TO [ENTRADAHEALTH\SQLImplementation]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Top / Bottom', 'SCHEMA', N'dbo', 'TABLE', N'Dictators', 'COLUMN', N'ESignatureLocation'
GO
*/