CREATE TABLE [dbo].[ExpressLinkConfigurations]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ApiKey] [uniqueidentifier] NOT NULL,
[ClinicID] [smallint] NOT NULL,
[EHRClinicID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EHRLocationID] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
[LastSync] [datetime] NULL,
[LastClinicalsSync] [datetime] NULL,
[ClientVersion] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_ExpressLinkConfigurations_ClientVersion] DEFAULT (''),
[EnableInboundData] [bit] NOT NULL CONSTRAINT [DF_ExpressLinkConfigurations_EnableInboundData] DEFAULT ((0)),
[EnableReturnOfWork] [bit] NOT NULL CONSTRAINT [DF_ExpressLinkConfigurations_EnableReturnOfWork] DEFAULT ((0)),
[Deleted] [bit] NULL CONSTRAINT [DF_ExpressLinkConfigurations_Deleted] DEFAULT ((0)),
[EnableAthenaACK] [bit] NULL CONSTRAINT [DF_ExpressLinkConfigurations_EnableAthenaACK] DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ExpressLinkConfigurations_ClinicID] ON [dbo].[ExpressLinkConfigurations] ([ClinicID]) ON [PRIMARY]

ALTER TABLE [dbo].[ExpressLinkConfigurations] ADD 
CONSTRAINT [PK_ExpressLinkConfigurations] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
