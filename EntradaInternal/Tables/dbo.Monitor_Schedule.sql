CREATE TABLE [dbo].[Monitor_Schedule]
(
[bintScheduleID] [bigint] NOT NULL IDENTITY(1, 1),
[intReportID] [int] NOT NULL,
[sScheduledDays] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[dteBeginTime] [datetime] NOT NULL,
[dteEndTime] [datetime] NOT NULL,
[dteLastRun] [datetime] NULL,
[dteCreateDate] [datetime] NOT NULL,
[dteModifiedDate] [datetime] NOT NULL,
[bitActive] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
