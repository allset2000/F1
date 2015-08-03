CREATE TABLE [dbo].[Job_History](
	[JobHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[JobNumber] [varchar](20) NOT NULL,
	[PatientId] [varchar](20) NULL,
	[JobType] [varchar](100) NULL,
	[CurrentStatus] [smallint] NOT NULL,
	[DocumentID] [int] NULL,
	[UserId] [varchar](100) NOT NULL,
	[HistoryDateTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[JobHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Job_History]  WITH CHECK ADD FOREIGN KEY([DocumentID])
REFERENCES [dbo].[Jobs_Documents_History] ([DocumentID])
GO

ALTER TABLE [dbo].[Job_History]  WITH CHECK ADD FOREIGN KEY([JobNumber])
REFERENCES [dbo].[Jobs] ([JobNumber])
GO



