CREATE TABLE [dbo].[OrphanJobsToProcess]
(
[JobNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_OrphanJobsToProcess_CreatedOn] DEFAULT (getdate())
) ON [PRIMARY]
GO
