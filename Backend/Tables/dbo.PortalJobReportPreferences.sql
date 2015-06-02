
CREATE TABLE [dbo].[PortalJobReportPreferences]
(
[Id] [smallint] NOT NULL IDENTITY(1, 1),
[UserName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateField] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Range] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[From] [date] NULL,
[To] [date] NULL,
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
[IsSaved] [bit] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PortalJobReportPreferences] ADD CONSTRAINT [PK_UserSearchPreferences] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO