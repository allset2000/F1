CREATE TABLE [dbo].[Monitor_Reports]
(
[intReportID] [int] NOT NULL IDENTITY(1, 1),
[sReportName] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sReportDesc] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bitActive] [bit] NOT NULL CONSTRAINT [DF_Monitor_Reports_bitActive] DEFAULT ((1)),
[dteCreateDate] [datetime] NOT NULL CONSTRAINT [DF_Monitor_Reports_dteCreateDate] DEFAULT (getdate()),
[dteModifiedDate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
