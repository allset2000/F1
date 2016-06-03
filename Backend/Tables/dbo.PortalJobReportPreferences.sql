SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PortalJobReportPreferences]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[UserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateField] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Range] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[From] [datetime] NULL,
[To] [datetime] NULL,
[JobType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobStatus] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DictatorID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MRN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDeviceGenerated] [bit] NULL,
[CC] [bit] NULL,
[STAT] [bit] NULL,
[SelectedColumns] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResultsPerPage] [smallint] NULL,
[SortBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SortType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClinicId] [smallint] NULL,
[ReportName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsSaved] [bit] NULL,
[CreatedDate] [datetime] NULL,
[UpdatedDate] [datetime] NULL,
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DictatorFirstName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DictatorLastName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[PortalJobReportPreferences] ADD 
CONSTRAINT [PK_UserSearchPreferences] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[PortalJobReportPreferences]  WITH NOCHECK ADD  CONSTRAINT [FK_PortalJobReportPreferences_Dictators] FOREIGN KEY([DictatorID])
REFERENCES [dbo].[Dictators] ([DictatorID])
GO

ALTER TABLE [dbo].[PortalJobReportPreferences] CHECK CONSTRAINT [FK_PortalJobReportPreferences_Dictators]
GO
