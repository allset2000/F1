SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PortalJobReportPreferences](
	[Id] [smallint] IDENTITY(1,1) NOT NULL,
	[UserID] [varchar](50) NOT NULL,
	[DateField] [varchar](50) NULL,
	[Range] [varchar](50) NULL,
	[From] [datetime] NULL,
	[To] [datetime] NULL,
	[JobType] [varchar](50) NULL,
	[JobStatus] [varchar](50) NULL,
	[DictatorID] [varchar](50) NULL,
	[MRN] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[IsDeviceGenerated] [bit] NULL,
	[CC] [bit] NULL,
	[STAT] [bit] NULL,
	[SelectedColumns] [varchar](500) NULL,
	[GroupBy] [varchar](50) NULL,
	[ResultsPerPage] [smallint] NULL,
	[SortBy] [varchar](50) NULL,
	[SortType] [varchar](50) NULL,
	[ClinicId] [smallint] NULL,
	[ReportName] [varchar](200) NULL,
	[IsSaved] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[JobNumber] [varchar](20) NULL,
 CONSTRAINT [PK_UserSearchPreferences] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[PortalJobReportPreferences]  WITH NOCHECK ADD  CONSTRAINT [FK_PortalJobReportPreferences_Dictators] FOREIGN KEY([DictatorID])
REFERENCES [dbo].[Dictators] ([DictatorID])
GO

ALTER TABLE [dbo].[PortalJobReportPreferences] CHECK CONSTRAINT [FK_PortalJobReportPreferences_Dictators]
GO


