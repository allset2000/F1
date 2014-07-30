CREATE TABLE [dbo].[Locations]
(
[ClinicID] [smallint] NOT NULL,
[LocationID] [smallint] NOT NULL,
[LocationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Address1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Manager] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ManagerPhone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[NumDaysToClose] [smallint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Locations] ADD CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED  ([ClinicID], [LocationID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Locations] ADD CONSTRAINT [FK_Locations_Clinics] FOREIGN KEY ([ClinicID]) REFERENCES [dbo].[Clinics] ([ClinicID])
GO
