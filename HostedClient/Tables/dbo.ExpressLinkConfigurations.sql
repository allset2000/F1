CREATE TABLE [dbo].[ExpressLinkConfigurations]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ApiKey] [uniqueidentifier] NOT NULL,
[ClinicID] [smallint] NOT NULL,
[EHRClinicID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EHRLocationID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EHRType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConnectionString] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Enabled] [bit] NOT NULL,
[SyncSetupData] [bit] NOT NULL,
[DaysForward] [smallint] NULL,
[DaysBack] [smallint] NULL,
[StartDate] [datetime] NOT NULL,
[LastPatientSync] [datetime] NULL,
[LastPhysicianSync] [datetime] NULL,
[LastScheduleSync] [datetime] NULL,
[LastClinicalsSync] [datetime] NULL,
[LastSync] [datetime] NULL,
[ClientVersion] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_ExpressLinkConfigurations_ClientVersion] DEFAULT (''),
[EnableInboundData] [bit] NOT NULL CONSTRAINT [DF_ExpressLinkConfigurations_EnableInboundData] DEFAULT ((0)),
[EnableReturnOfWork] [bit] NOT NULL CONSTRAINT [DF_ExpressLinkConfigurations_EnableReturnOfWork] DEFAULT ((0)),
[ClientIP] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientPortNo] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ExpressLinkConfigurations] ADD CONSTRAINT [PK_ExpressLinkConfigurations] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
